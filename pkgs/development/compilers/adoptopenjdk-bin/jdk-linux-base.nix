sourcePerArch:

{ swingSupport ? true
, stdenv
, fetchurl
, file
, xorg ? null
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
}:

assert swingSupport -> xorg != null;

let
  rSubPaths = [
    "lib/jli"
    "lib/server"
    "lib/compressedrefs" # OpenJ9
    "lib/j9vm" # OpenJ9
    "lib"
  ];

  libraries = [
    stdenv.cc.libc glib libxml2 ffmpeg_2 libxslt libGL
    xorg.libXxf86vm alsaLib fontconfig freetype pango gtk2 cairo gdk_pixbuf
    atk zlib elfutils
  ] ++ (stdenv.lib.optionals swingSupport [
    xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXp xorg.libXt
    xorg.libXrender
    stdenv.cc.cc
  ]);
in

let result = stdenv.mkDerivation rec {
  name = if sourcePerArch.packageType == "jdk"
    then "adoptopenjdk-${sourcePerArch.vmType}-bin-${sourcePerArch.version}"
    else "adoptopenjdk-${sourcePerArch.packageType}-${sourcePerArch.vmType}-bin-${sourcePerArch.version}";

  src = fetchurl {
    inherit (sourcePerArch.${stdenv.hostPlatform.parsed.cpu.name}) url sha256;
  };

  nativeBuildInputs = [ file ];

  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase = ''
    cd ..

    mv $sourceRoot $out

    rm -rf $out/demo

    # Remove some broken manpages.
    rm -rf $out/man/ja*

    # for backward compatibility
    ln -s $out $out/jre

    mkdir -p $out/nix-support

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
  '';

  rpath = stdenv.lib.strings.makeLibraryPath libraries;

  # FIXME: use multiple outputs or return actual JRE package
  passthru.jre = result;

  passthru.home = result;

  # for backward compatibility
  passthru.architecture = "";

  meta = with stdenv.lib; {
    license = licenses.gpl2Classpath;
    description = "AdoptOpenJDK, prebuilt OpenJDK binary";
    platforms = stdenv.lib.mapAttrsToList (arch: _: arch + "-linux") sourcePerArch; # some inherit jre.meta.platforms
    maintainers = with stdenv.lib.maintainers; [ taku0 ];
  };

}; in result
