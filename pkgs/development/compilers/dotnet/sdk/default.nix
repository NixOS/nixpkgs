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
    version = "2.2.401";
    netCoreVersion = "2.2.6";
    pname = "dotnet-sdk";

    src = fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
      # use sha512 from the download page
      sha512 = "05w3zk7bcd8sv3k4kplf20j906and2006g1fggq7y6kaxrlhdnpd6jhy6idm8v5bz48wfxga5b4yys9qx0fp3p8yl7wi67qljpzrq88";
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
