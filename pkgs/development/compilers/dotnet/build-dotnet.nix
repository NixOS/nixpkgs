{ type
, version
, srcs
, icu #passing icu as an argument, because dotnet 3.1 has troubles with icu71
}:

assert builtins.elem type [ "aspnetcore" "runtime" "sdk"];

{ lib
, stdenv
, fetchurl
, writeText
, libunwind
, openssl
, libuuid
, zlib
, curl
, lttng-ust_2_12
}:

let
  pname = if type == "aspnetcore" then
    "aspnetcore-runtime"
  else if type == "runtime" then
    "dotnet-runtime"
  else
    "dotnet-sdk";

  descriptions = {
    aspnetcore = "ASP.NET Core Runtime ${version}";
    runtime = ".NET Runtime ${version}";
    sdk = ".NET SDK ${version}";
  };
in stdenv.mkDerivation rec {
  inherit pname version;

  # Some of these dependencies are `dlopen()`ed.
  rpath = lib.makeLibraryPath ([
    stdenv.cc.cc
    zlib
    curl
    icu
    libunwind
    libuuid
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    lttng-ust_2_12
  ]);

  src = fetchurl (srcs."${stdenv.hostPlatform.system}" or (throw
    "Missing source (url and hash) for host system: ${stdenv.hostPlatform.system}"));

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
    find $out -type f \( -name "apphost" -or -name "createdump" \) -exec patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" --set-rpath '$ORIGIN:${rpath}' {} \;
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dotnet --info
  '';

  setupHook = writeText "dotnet-setup-hook" ''
    if [ ! -w "$HOME" ]; then
      export HOME=$(mktemp -d) # Dotnet expects a writable home directory for its configuration files
    fi

    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 # Dont try to expand NuGetFallbackFolder to disk
    export DOTNET_NOLOGO=1 # Disables the welcome message
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = builtins.getAttr type descriptions;
    homepage = "https://dotnet.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero mdarocha ];
    mainProgram = "dotnet";
    platforms = builtins.attrNames srcs;
  };
}
