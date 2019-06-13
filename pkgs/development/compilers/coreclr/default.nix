{ config, stdenv
, fetchFromGitHub
, fetchpatch
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
, debug ? config.coreclr.debug or false
}:

stdenv.mkDerivation rec {
  name = "coreclr-${version}";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner  = "dotnet";
    repo   = "coreclr";
    rev    = "v${version}";
    sha256 = "0pzkrfgqywhpijbx7j1v4lxa6270h6whymb64jdkp7yj56ipqh2n";
  };

  patches = [
    (fetchpatch {
      # glibc 2.26
      url = https://github.com/dotnet/coreclr/commit/a8f83b615708c529b112898e7d2fbc3f618b26ee.patch;
      sha256 = "047ph5gip4z2h7liwdxsmpnlaq0sd3hliaw4nyqjp647m80g3ffq";
    })
    (fetchpatch {
      # clang 5
      url = https://github.com/dotnet/coreclr/commit/9b22e1a767dee38f351001c5601f56d78766a43e.patch;
      sha256 = "1w1lxw5ryvhq8m5m0kv880c4bh6y9xdgypkr76sqbh3v568yghzg";
    })
  ];

  nativeBuildInputs = [
    which
    cmake
    clang
  ];

  buildInputs = [
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
    # disable -Werror which can potentially breaks with every compiler upgrade
    ./build.sh $BuildArch $BuildType cmakeargs "-DCLR_CMAKE_WARNINGS_ARE_ERRORS=OFF"
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
    homepage = https://github.com/dotnet/core/;
    description = ".NET is a general purpose development platform";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kuznero ];
    license = licenses.mit;
  };
}
