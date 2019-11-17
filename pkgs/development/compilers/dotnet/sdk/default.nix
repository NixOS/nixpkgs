{ stdenv
, fetchurl
, libunwind
, openssl
, icu
, libuuid
, zlib
, curl
}:

let
  rpath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc libunwind libuuid icu openssl zlib curl ];
in
  stdenv.mkDerivation rec {
    version = "3.0.100";
    netCoreVersion = "3.0.0";
    pname = "dotnet-sdk";

    src = fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
      # use sha512 from the download page
      sha512 = "766da31f9a0bcfbf0f12c91ea68354eb509ac2111879d55b656f19299c6ea1c005d31460dac7c2a4ef82b3edfea30232c82ba301fb52c0ff268d3e3a1b73d8f7";
    };

    sourceRoot = ".";

    buildPhase = ''
      runHook preBuild
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ./dotnet
      patchelf --set-rpath "${rpath}" ./dotnet
      find -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
      echo -n "dotnet-sdk version: "
      ./dotnet --version
      runHook postBuild
    '';

    dontPatchELF = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -r ./ $out
      ln -s $out/dotnet $out/bin/dotnet
      runHook postInstall
    '';

    meta = with stdenv.lib; {
      homepage = https://dotnet.github.io/;
      description = ".NET Core SDK ${version} with .NET Core ${netCoreVersion}";
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ kuznero ];
      license = licenses.mit;
    };
  }
