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
    version = "2.2.103";
    netCoreVersion = "2.2.1";
    name = "dotnet-sdk-${version}";

    src = fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/dotnet-sdk-${version}-linux-x64.tar.gz";
      # use sha512 from the download page
      sha512 = "777AC6DCD0200BA447392E451A1779F0FBFA548BD620A7BBA3EEBDF35892236C3F10B19FF81D4F64B5BC134923CB47F9CC45EE6B004140E1249582249944DB69";
    };

    unpackPhase = ''
      mkdir src
      cd src
      tar xvzf $src
    '';

    buildPhase = ''
      runHook preBuild
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./dotnet
      patchelf --set-rpath "${rpath}" ./dotnet
      find -type f -name "*.so" -exec patchelf --set-rpath "${rpath}" {} \;
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
