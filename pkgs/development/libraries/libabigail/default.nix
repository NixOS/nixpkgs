{ lib, stdenv
, fetchurl
, autoreconfHook
, elfutils
, libxml2
, pkg-config
, strace
, python3
}:

stdenv.mkDerivation rec {
  pname = "libabigail";
  version = "2.5";

  outputs = [ "bin" "out" "dev" ];

  src = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-fPxOmwCuONh/sMY76rsyucv5zkEOUs7rWtWzxb6xEfM=";
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
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
