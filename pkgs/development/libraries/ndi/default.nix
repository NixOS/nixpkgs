{ stdenv, requireFile, avahi }:

stdenv.mkDerivation rec {
  pname = "ndi";
  fullVersion = "4.1.6";
  version = builtins.head (builtins.splitVersion fullVersion);

  src = requireFile rec {
    name    = "InstallNDISDK_v${version}_Linux.tar.gz";
    sha256  = "0hki805j3hlci6w5ca2cajm5q0y9yihgvpsykkn8dzx8chw4pmsk";
    message = ''
      In order to use NDI SDK version ${fullVersion}, you need to comply with
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
    echo y | ./InstallNDISDK_v4_Linux.sh
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

  meta = with stdenv.lib; {
    homepage = "https://ndi.tv/sdk/";
    description = "NDI Software Developer Kit";
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
    license = licenses.unfree;
  };
}
