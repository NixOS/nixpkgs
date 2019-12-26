{ stdenv, fetchurl, glib, git,
  rlwrap, curl, pkgconfig, perl, makeWrapper, tzdata, ncurses,
  pango, cairo, gtk2, gdk-pixbuf, gtkglext,
  mesa, xorg, openssl, unzip }:

stdenv.mkDerivation rec {
  pname = "factor-lang";
  version = "0.98";
  rev = "7999e72aecc3c5bc4019d43dc4697f49678cc3b4";

  src = fetchurl {
    url = https://downloads.factorcode.org/releases/0.98/factor-src-0.98.zip;
    sha256 = "01ip9mbnar4sv60d2wcwfz62qaamdvbykxw3gbhzqa25z36vi3ri";
  };

  patches = [
    ./staging-command-line-0.98-pre.patch
    ./workdir-0.98-pre.patch
    ./fuel-dir.patch
  ];

  buildInputs = with xorg; [ git rlwrap curl pkgconfig perl makeWrapper
    libX11 pango cairo gtk2 gdk-pixbuf gtkglext
    mesa libXmu libXt libICE libSM openssl unzip ];

  buildPhase = ''
    sed -ie '4i GIT_LABEL = heads/master-${rev}' GNUmakefile
    make linux-x86-64
    # De-memoize xdg-* functions, otherwise they break the image.
    sed -ie 's/^MEMO:/:/' basis/xdg/xdg.factor
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/factor
    # The released image has library path info embedded, so we
    # first have to recreate the boot image with Nix paths, and
    # then use it to build the Nix release image.
    cp boot.unix-x86.64.image $out/lib/factor/factor.image

    cp -r basis core extra $out/lib/factor

    # Factor uses XDG_CACHE_HOME for cache during compilation.
    # We can't have that. So set it to $TMPDIR/.cache
    export XDG_CACHE_HOME=$TMPDIR/.cache && mkdir -p $XDG_CACHE_HOME

    # There is no ld.so.cache in NixOS so we construct one
    # out of known libraries. The side effect is that find-lib
    # will work only on the known libraries. There does not seem
    # to be a generic solution here.
    find $(echo ${stdenv.lib.makeLibraryPath (with xorg; [
        glib libX11 pango cairo gtk2 gdk-pixbuf gtkglext
        mesa libXmu libXt libICE libSM ])} | sed -e 's#:# #g') -name \*.so.\* > $TMPDIR/so.lst

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
      "${stdenv.lib.makeLibraryPath (with xorg; [ glib
        libX11 pango cairo gtk2 gdk-pixbuf gtkglext
        mesa libXmu libXt libICE libSM openssl])}"

    sed -ie 's#/bin/.factor-wrapped#/lib/factor/factor#g' $out/bin/factor
    mv $out/bin/.factor-wrapped $out/lib/factor/factor

    # build full factor image from boot image
    (cd $out/bin && ./factor  -script -e='"unix-x86.64" USING: system bootstrap.image memory ; make-image save 0 exit' )

    # make a new bootstrap image
    (cd $out/bin && ./factor  -script -e='"unix-x86.64" USING: system tools.deploy.backend ; make-boot-image 0 exit' )

    # rebuild final full factor image to include all patched sources
    (cd $out/lib/factor && ./factor -i=boot.unix-x86.64.image)

    # install fuel mode for emacs
    mkdir -p $out/share/emacs/site-lisp
    # update default paths in factor-listener.el for fuel mode
    substituteInPlace misc/fuel/fuel-listener.el \
      --subst-var-by fuel_factor_root_dir $out/lib/factor \
      --subst-var-by fuel_listener_factor_binary $out/bin/factor
    cp misc/fuel/*.el $out/share/emacs/site-lisp/
  '';

  meta = with stdenv.lib; {
    homepage = https://factorcode.org;
    license = licenses.bsd2;
    description = "A concatenative, stack-based programming language";

    maintainers = [ maintainers.vrthra maintainers.spacefrogg ];
    platforms = [ "x86_64-linux" ];
  };
}
