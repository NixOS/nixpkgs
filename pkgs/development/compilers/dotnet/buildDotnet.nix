{ type
, version
, sha512
}:
assert builtins.elem type [ "aspnetcore" "netcore" "sdk"];
{ stdenv
, fetchurl
, libunwind
, openssl
, icu
, libuuid
, zlib
, curl
}: 
let pname = if type == "aspnetcore" then "aspnetcore-runtime" else if type == "netcore" then "dotnet-runtime" else "dotnet-sdk";
    urls = {
        aspnetcore = "https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${version}/${pname}-${version}-linux-x64.tar.gz";
        netcore = "https://dotnetcli.azureedge.net/dotnet/Runtime/${version}/${pname}-${version}-linux-x64.tar.gz";
        sdk = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
    };
    descriptions = {
        aspnetcore = "ASP .NET Core runtime ${version}";
        netcore = ".NET Core runtime ${version}";
        sdk = ".NET SDK ${version}";
    };
in stdenv.mkDerivation rec {
    inherit pname version;

    rpath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc libunwind libuuid icu openssl zlib curl ];

    src = fetchurl {
        url = builtins.getAttr type urls;
        inherit sha512;
    };

    sourceRoot = ".";

    dontPatchELF = true;
    noDumpEnvVars = true;

    installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp -r ./ $out
        ln -s $out/dotnet $out/bin/dotnet
        runHook postInstall
    '';

    postFixup = ''
        patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/dotnet
        patchelf --set-rpath "${rpath}" $out/dotnet
        find $out -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
        find $out -type f -name "apphost" -exec patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" --set-rpath '$ORIGIN:${rpath}' {} \;
    '';

    doInstallCheck = true;
    installCheckPhase = ''
        $out/bin/dotnet --info
    '';

    meta = with stdenv.lib; {
        homepage = https://dotnet.github.io/;
        description = builtins.getAttr type descriptions;
        platforms = [ "x86_64-linux" ];
        maintainers = with maintainers; [ kuznero ];
        license = licenses.mit;
    };
}
