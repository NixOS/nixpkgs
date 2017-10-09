{ stdenv
, fetchFromGitHub
, which
, cmake
, clang
, llvmPackages
, libunwind
, gettext
, openssl
, python2
, icu
, lttng-ust
, liburcu
, libuuid
, libkrb5
, debug ? false
}:

stdenv.mkDerivation rec {
  name = "coreclr-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner  = "dotnet";
    repo   = "coreclr";
    rev    = "v${version}";
    sha256 = "16z58ix8kmk8csfy5qsqz8z30czhrap2vb8s8vdflmbcfnq31jcw";
  };

  buildInputs = [
    which
    cmake
    clang
    llvmPackages.llvm
    llvmPackages.lldb
    libunwind
    gettext
    openssl
    python2
    icu
    lttng-ust
    liburcu
    libuuid
    libkrb5
  ];

  configurePhase = ''
    # override to avoid cmake running
    patchShebangs .
  '';

  BuildArch = if stdenv.is64bit then "x64" else "x86";
  BuildType = if debug then "Debug" else "Release";

  hardeningDisable = [
    "strictoverflow"
    "format"
  ];

  buildPhase = ''
    runHook preBuild
    ./build.sh $BuildArch $BuildType
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/dotnet $out/bin
    cp -r bin/Product/Linux.$BuildArch.$BuildType/* $out/share/dotnet
    for cmd in coreconsole corerun createdump crossgen ilasm ildasm mcs superpmi; do
      ln -s $out/share/dotnet/$cmd $out/bin/$cmd
    done
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://dotnet.github.io/core/;
    description = ".NET is a general purpose development platform";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kuznero ];
    license = licenses.mit;
  };
}
