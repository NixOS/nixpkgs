{ lib, stdenv, requireFile, avahi, obs-studio-plugins }:

let
  versionJSON = lib.importJSON ./version.json;
  ndiPlatform =
    if stdenv.isAarch64 then "aarch64-rpi4-linux-gnueabi"
    else if stdenv.isAarch32 then "arm-rpi2-linux-gnueabihf"
    else if stdenv.isx86_64 then "x86_64-linux-gnu"
    else if stdenv.isi686 then "i686-linux-gnu"
    else throw "unsupported platform for NDI SDK";
in
stdenv.mkDerivation rec {
  pname = "ndi";
  version = versionJSON.version;
  majorVersion = builtins.head (builtins.splitVersion version);
  installerName = "Install_NDI_SDK_v${majorVersion}_Linux";

  src = requireFile rec {
    name    = "${installerName}.tar.gz";
    sha256  = versionJSON.hash;
    message = ''
      In order to use NDI SDK version ${version}, you need to comply with
      NewTek's license and download the appropriate Linux tarball from:

        ${meta.homepage}

      Once you have downloaded the file, please use the following command and
      re-run the installation:

        \$ nix-prefetch-url file://\$PWD/${name}
    '';
  };

  buildInputs = [ avahi ];

  unpackPhase = ''
    unpackFile $src
    echo y | ./${installerName}.sh
    sourceRoot="NDI SDK for Linux";
  '';

  installPhase = ''
    mkdir $out
    mv bin/${ndiPlatform} $out/bin
    for i in $out/bin/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"
    done
    patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" $out/bin/ndi-record
    mv lib/${ndiPlatform} $out/lib
    for i in $out/lib/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" "$i"
    done
    mv include examples $out/
    mkdir -p $out/share/doc/${pname}-${version}
    mv licenses $out/share/doc/${pname}-${version}/licenses
    mv documentation/* $out/share/doc/${pname}-${version}/
  '';

  # Stripping breaks ndi-record.
  dontStrip = true;

  passthru.tests = {
    inherit (obs-studio-plugins) obs-ndi;
  };
  passthru.updateScript = ./update.py;

  meta = with lib; {
    homepage = "https://ndi.video/ndi-sdk/";
    description = "NDI Software Developer Kit";
    platforms = ["x86_64-linux" "i686-linux" "aarch64-linux" "armv7l-linux"];
    hydraPlatforms = [];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
  };
}
