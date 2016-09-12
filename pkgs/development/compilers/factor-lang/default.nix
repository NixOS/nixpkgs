{ stdenv, fetchurl, fetchFromGitHub, glib, glibc, git,
  rlwrap, curl, pkgconfig, perl, makeWrapper, tzdata, ncurses,
  libX11, pango, cairo, gtk2, gdk_pixbuf, gtkglext,
  mesa, libXmu, libXt, libICE, libSM }:

stdenv.mkDerivation rec {
  name = "factor-lang-${version}";
  version = "0.97";
  rev = "eb3ca179740e6cfba696b55a999caa13369e6182";

  src = fetchFromGitHub {
    owner = "factor";
    repo = "factor";
    rev = rev;
    sha256 = "16zlbxbad3d19jq01nk824i19bypqzn8l3yfxys40z06vjjncapd";
  };

  factorimage = fetchurl {
    url = http://downloads.factorcode.org/releases/0.97/factor-linux-x86-64-0.97.tar.gz;
    sha256 = "06y125c8vbng54my5fxdr3crpxkvhhcng2n35cxddd3wcg6vhxhp";
    name = "factorimage";
  };

  buildInputs = [ git rlwrap curl pkgconfig perl makeWrapper
    libX11 pango cairo gtk2 gdk_pixbuf gtkglext
    mesa libXmu libXt libICE libSM ];

  buildPhase = ''
    make $(bash ./build-support/factor.sh make-target) GIT_LABEL=heads/master-${rev}
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/factor
    # First, get a workable image. Unfortunately, no boot-image
    # is available with release info. So fetch a released image.
    # The released image has library path info embedded, so we
    # have to first recreate the boot image with Nix paths, and
    # then use it to build the Nix release image.
    zcat ${factorimage} | (cd $out/lib && tar -xvpf - factor/factor.image )

    cp -r basis core extra unmaintained $out/lib/factor

    # Factor uses the home directory for cache during compilation.
    # We cant have that. So set it to $TMPDIR/.home
    export HOME=$TMPDIR/.home && mkdir -p $HOME

    # there is no ld.so.cache in NixOS so we construct one
    # out of known libraries. The side effect is that find-lib
    # will work only on the known libraries. There does not seem
    # to be a generic solution here.
    find $(echo ${stdenv.lib.makeLibraryPath [
        glib libX11 pango cairo gtk2 gdk_pixbuf gtkglext
        mesa libXmu libXt libICE libSM ]} | sed -e 's#:# #g') -name \*.so.\* > $TMPDIR/so.lst

    (echo $(cat $TMPDIR/so.lst | wc -l) "libs found in cache \`/etc/ld.so.cache'";
    for l in $(<$TMPDIR/so.lst);
    do
      echo "	$(basename $l) (libc6,x86-64) => $l";
    done)> $out/lib/factor/ld.so.cache

    sed -ie "s#/sbin/ldconfig -p#cat $out/lib/factor/ld.so.cache#g" \
      $out/lib/factor/basis/alien/libraries/finder/linux/linux.factor

    sed -ie 's#/usr/share/zoneinfo/#${tzdata}/share/zoneinfo/#g' \
      $out/lib/factor/extra/tzinfo/tzinfo.factor

    sed -ie 's#/usr/share/terminfo#${ncurses.out}/share/terminfo#g' \
      $out/lib/factor/extra/terminfo/terminfo.factor

    cp ./factor $out/bin
    wrapProgram $out/bin/factor --prefix LD_LIBRARY_PATH : \
      "${stdenv.lib.makeLibraryPath [ glib
        libX11 pango cairo gtk2 gdk_pixbuf gtkglext
        mesa libXmu libXt libICE libSM ]}"

    sed -ie 's#/bin/.factor-wrapped#/lib/factor/factor#g' $out/bin/factor
    mv $out/bin/.factor-wrapped $out/lib/factor/factor

    # make a new bootstrap image
    (cd $out/bin && ./factor  -script -e='"unix-x86.64" USING: system bootstrap.image memory ; make-image save 0 exit' )
    mv $out/lib/factor/boot.unix-x86.64.image $out/lib/factor/factor.image
    # now make the full system image, it overwrites $out/lib/factor/factor.image
    $out/bin/factor -i=$out/lib/factor/factor.image
  '';

  meta = with stdenv.lib; {
    homepage = http://factorcode.org;
    license = licenses.bsd2;
    description = "A concatenative, stack-based programming language";

    maintainers = [ maintainers.vrthra ];
    platforms = [ "x86_64-linux" ];
  };
}
