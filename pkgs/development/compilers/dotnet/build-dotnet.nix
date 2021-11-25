{ type
, version
, sha512
}:

assert builtins.elem type [ "aspnetcore" "runtime" "sdk"];
{ lib, stdenv
, fetchurl
, libunwind
, openssl
, icu
, libuuid
, zlib
, curl
}:

let
  pname = if type == "aspnetcore" then
    "aspnetcore-runtime"
  else if type == "runtime" then
    "dotnet-runtime"
  else
    "dotnet-sdk";
  platform = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "osx-x64";
    aarch64-darwin = "osx-arm64";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
  urls = {
    aspnetcore = "https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${version}/${pname}-${version}-${platform}.tar.gz";
    runtime = "https://dotnetcli.azureedge.net/dotnet/Runtime/${version}/${pname}-${version}-${platform}.tar.gz";
    sdk = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}.tar.gz";
  };
  descriptions = {
    aspnetcore = "ASP.NET Core Runtime ${version}";
    runtime = ".NET Runtime ${version}";
    sdk = ".NET SDK ${version}";
  };
in stdenv.mkDerivation rec {
  inherit pname version;

  rpath = lib.makeLibraryPath [
    curl
    icu
    libunwind
    libuuid
    openssl
    stdenv.cc.cc
    zlib
  ];

  src = fetchurl {
    url = builtins.getAttr type urls;
    sha512 = sha512."${stdenv.hostPlatform.system}" or (throw
      "Missing hash for host system: ${stdenv.hostPlatform.system}");
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

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/dotnet
    patchelf --set-rpath "${rpath}" $out/dotnet
    find $out -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
    find $out -type f -name "apphost" -exec patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" --set-rpath '$ORIGIN:${rpath}' {} \;
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dotnet --info
  '';

  meta = with lib; {
    homepage = "https://dotnet.github.io/";
    description = builtins.getAttr type descriptions;
    platforms = builtins.attrNames sha512;
    maintainers = with maintainers; [ kuznero ];
    license = licenses.mit;
  };
}
