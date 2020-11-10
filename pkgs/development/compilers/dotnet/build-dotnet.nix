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

let
  pname = if type == "aspnetcore" then
    "aspnetcore-runtime"
  else if type == "netcore" then
    "dotnet-runtime"
  else
    "dotnet-sdk";
  platform = if stdenv.isDarwin then "osx" else "linux";
  suffix = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    x86_64-darwin = "x64";
  }."${stdenv.hostPlatform.system}" or (throw
    "Unsupported system: ${stdenv.hostPlatform.system}");
  urls = {
    aspnetcore = "https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
    netcore = "https://dotnetcli.azureedge.net/dotnet/Runtime/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
    sdk = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
  };
  descriptions = {
    aspnetcore = "ASP .NET Core runtime ${version}";
    netcore = ".NET Core runtime ${version}";
    sdk = ".NET SDK ${version}";
  };
in stdenv.mkDerivation rec {
  inherit pname version;

  rpath = stdenv.lib.makeLibraryPath [
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

  postFixup = stdenv.lib.optionalString stdenv.isLinux ''
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
    homepage = "https://dotnet.github.io/";
    description = builtins.getAttr type descriptions;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ kuznero ];
    license = licenses.mit;
  };
}
