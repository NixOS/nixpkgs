sourcePerArch:

{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, alsaLib
, freetype
, fontconfig
, zlib
, xorg
, libffi
}:

let
  cpuName = stdenv.hostPlatform.parsed.cpu.name;
in

let result = stdenv.mkDerivation rec {
  name = if sourcePerArch.packageType == "jdk"
    then "adoptopenjdk-${sourcePerArch.vmType}-bin-${version}"
    else "adoptopenjdk-${sourcePerArch.packageType}-${sourcePerArch.vmType}-bin-${version}";

  version = sourcePerArch.${cpuName}.version or (throw "unsupported CPU ${cpuName}");

  src = fetchurl {
    inherit (sourcePerArch.${cpuName}) url sha256;
  };

  buildInputs = [
    alsaLib freetype fontconfig zlib xorg.libX11 xorg.libXext xorg.libXtst
    xorg.libXi xorg.libXrender
  ] ++ lib.optional stdenv.isAarch32 libffi;

  nativeBuildInputs = [ autoPatchelfHook ];

  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase = ''
    cd ..

    mv $sourceRoot $out

    rm -rf $out/demo

    # Remove some broken manpages.
    rm -rf $out/man/ja*

    # Remove embedded freetype to avoid problems like
    # https://github.com/NixOS/nixpkgs/issues/57733
    find "$out" -name 'libfreetype.so*' -delete

    mkdir -p $out/nix-support

    # Set JAVA_HOME automatically.
    cat <<EOF >> "$out/nix-support/setup-hook"
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  preFixup = ''
    find "$out" -name libfontmanager.so -exec \
      patchelf --add-needed libfontconfig.so {} \;
  '';

  # FIXME: use multiple outputs or return actual JRE package
  passthru.jre = result;

  passthru.home = result;

  meta = with stdenv.lib; {
    license = licenses.gpl2Classpath;
    description = "AdoptOpenJDK, prebuilt OpenJDK binary";
    platforms = lib.mapAttrsToList (arch: _: arch + "-linux") sourcePerArch; # some inherit jre.meta.platforms
    maintainers = with lib.maintainers; [ taku0 ];
  };

}; in result
