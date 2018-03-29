{ swingSupport ? true
, stdenv
, requireFile
, makeWrapper
, unzip
, file
, xorg ? null
, packageType ? "JDK" # JDK, JRE, or ServerJRE
, pluginSupport ? true
, glib
, libxml2
, ffmpeg_2
, libxslt
, libGL
, freetype
, fontconfig
, gtk2
, pango
, cairo
, alsaLib
, atk
, gdk_pixbuf
, zlib
, elfutils
, setJavaClassPath
}:

assert stdenv.system == "x86_64-linux";
assert swingSupport -> xorg != null;

let
  version = "10";

  downloadUrlBase = http://www.oracle.com/technetwork/java/javase/downloads;

  rSubPaths = [
    "lib/jli"
    "lib/server"
    "lib"
  ];

in

let result = stdenv.mkDerivation rec {
  name = if packageType == "JDK"       then "oraclejdk-${version}"
    else if packageType == "JRE"       then "oraclejre-${version}"
    else if packageType == "ServerJRE" then "oracleserverjre-${version}"
    else abort "unknown package Type ${packageType}";

  src =
    if packageType == "JDK" then
      requireFile {
        name = "jdk-${version}_linux-x64_bin.tar.gz";
        url =  "${downloadUrlBase}/jdk10-downloads-4416644.html";
        sha256 = "0338m0x5lka0xjsbcll70r1i308bjw3m42cm9dx9zmfk70kplj5c";
      }
    else if packageType == "JRE" then
      requireFile {
        name = "jre-${version}_linux-x64_bin.tar.gz";
        url = "${downloadUrlBase}/jre10-downloads-4417026.html";
        sha256 = "1clawcahkla1h9pxnqfqzcgv51aqgq78v1ws5jygbk6fbbi7l54w";
      }
    else if packageType == "ServerJRE" then
      requireFile {
        name = "serverjre-${version}_linux-x64_bin.tar.gz";
        url = "${downloadUrlBase}/sjre10-downloads-4417025.html";
        sha256 = "0kiyg33fv29ad0nyl35r7y0bhyxivb2hxlds44m9l0259s55nwhw";
      }
    else abort "unknown package Type ${packageType}";

  nativeBuildInputs = [ file ];

  buildInputs = [ makeWrapper ];

  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase = ''
    cd ..

    # Set PaX markings
    exes=$(file $sourceRoot/bin/* 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//')
    for file in $exes; do
      paxmark m "$file"
      # On x86 for heap sizes over 700MB disable SEGMEXEC and PAGEEXEC as well.
      ${stdenv.lib.optionalString stdenv.isi686 ''paxmark msp "$file"''}
    done

    mv $sourceRoot $out

    shopt -s extglob
    for file in $out/*
    do
      if test -f $file ; then
        rm $file
      fi
    done

    if test -z "$pluginSupport"; then
      rm -f $out/bin/javaws
    fi

    mkdir $out/lib/plugins
    ln -s $out/lib/libnpjp2.so $out/lib/plugins

    # for backward compatibility
    ln -s $out $out/jre

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  postFixup = ''
    rpath+="''${rpath:+:}${stdenv.lib.concatStringsSep ":" (map (a: "$out/${a}") rSubPaths)}"

    # set all the dynamic linkers
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;

    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    # Oracle Java Mission Control needs to know where libgtk-x11 and related is
    if test -x $out/bin/jmc; then
      wrapProgram "$out/bin/jmc" \
          --suffix-each LD_LIBRARY_PATH ':' "$rpath"
    fi
  '';

  /**
   * libXt is only needed on amd64
   */
  libraries =
    [stdenv.cc.libc glib libxml2 ffmpeg_2 libxslt libGL xorg.libXxf86vm alsaLib fontconfig freetype pango gtk2 cairo gdk_pixbuf atk zlib elfutils] ++
    (if swingSupport then [xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXp xorg.libXt xorg.libXrender stdenv.cc.cc] else []);

  rpath = stdenv.lib.strings.makeLibraryPath libraries;

  passthru.mozillaPlugin = "/lib/plugins";

  passthru.jre = result; # FIXME: use multiple outputs or return actual JRE package

  passthru.home = result;

  # for backward compatibility
  passthru.architecture = "";

  meta = with stdenv.lib; {
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ]; # some inherit jre.meta.platforms
  };

}; in result
