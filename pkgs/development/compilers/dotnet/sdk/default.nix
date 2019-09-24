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
    version = "2.2.402";
    netCoreVersion = "2.2.7";
    pname = "dotnet-sdk";

    src = fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
      # use sha512 from the download page
      sha512 = "129pnngq2c16cy58zdh47grkf36k9kj39l3zpr8jxapzlin85i3wwwglwv97jp758bd0q5syvprvg84kv7x2difnkikgs2fhzh7v4w1";
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
      maintainers = with maintainers; [ kuznero ];
      license = licenses.mit;
    };
  }
