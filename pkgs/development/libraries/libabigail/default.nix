{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  elfutils,
  libxml2,
  pkg-config,
  strace,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libabigail";
  version = "2.1";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-SmKX1B0V0ZNiVhFxFr1hKW5rm+4j1UoMr40/WrjdzEw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    strace
  ];

  buildInputs = [
    elfutils
    libxml2
  ];

  nativeCheckInputs = [
    python3
  ];

  configureFlags = [
    "--enable-bash-completion=yes"
    "--enable-cxx11=yes"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    # runtestdiffpkg needs cache directory
    export XDG_CACHE_HOME="$TEMPDIR"
    patchShebangs tests/
  '';

  meta = with lib; {
    description = "ABI Generic Analysis and Instrumentation Library";
    homepage = "https://sourceware.org/libabigail/";
    license = licenses.asl20-llvm;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
