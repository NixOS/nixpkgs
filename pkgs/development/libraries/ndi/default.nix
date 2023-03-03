{ lib, stdenv, requireFile, avahi, obs-studio-plugins }:

let
  versionJSON = builtins.fromJSON (builtins.readFile ./version.json);
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
    unpackFile ${src}
    echo y | ./${installerName}.sh
    sourceRoot="NDI SDK for Linux";
  '';

  installPhase = ''
    mkdir $out
    mv bin/x86_64-linux-gnu $out/bin
    for i in $out/bin/*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"
    done
    patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" $out/bin/ndi-record
    mv lib/x86_64-linux-gnu $out/lib
    for i in $out/lib/*; do
      if [ -L "$i" ]; then continue; fi
      patchelf --set-rpath "${avahi}/lib:${stdenv.cc.libc}/lib" "$i"
    done
    mv include examples $out/
    mkdir -p $out/share/doc/${pname}-${version}
    mv licenses $out/share/doc/${pname}-${version}/licenses
    mv logos $out/share/doc/${pname}-${version}/logos
    mv documentation/* $out/share/doc/${pname}-${version}/
  '';

  # Stripping breaks ndi-record.
  dontStrip = true;

  passthru.tests = {
    inherit (obs-studio-plugins) obs-ndi;
  };
  passthru.updateScript = ./update.py;

  meta = with lib; {
    homepage = "https://ndi.tv/sdk/";
    description = "NDI Software Developer Kit";
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
  };
}
