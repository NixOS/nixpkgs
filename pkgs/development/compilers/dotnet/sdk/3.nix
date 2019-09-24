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
      sha512 = "3vxhwqv78z8s9pzq19gn0d35g4340m3zvnv70pglk1cgnk02k9hbh51dsf2j6bgcmdxay8q2719ll7baj1sc7n9287vzkqbk8gs6vbn";
    };

    sourceRoot = ".";

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -r ./ $out
      ln -s $out/dotnet $out/bin/dotnet
      runHook postInstall
    '';

    dontPatchelf = true;

    # the dotnet executable cannot be wrapped, must use patchelf.
    # autoPatchelf isn't able to be used as libicu* and other's aren't
    # listed under typical binary section
    postFixup = ''
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/dotnet
      patchelf --set-rpath "${rpath}" $out/dotnet
      find $out -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      $out/bin/dotnet --info
    '';

    meta = with stdenv.lib; {
      homepage = https://dotnet.github.io/;
      description = ".NET Core SDK ${version} with .NET Core ${netCoreVersion}";
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ jonringer ];
      license = licenses.mit;
    };
  }
