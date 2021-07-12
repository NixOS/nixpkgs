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
  version = "1.8.2";

  outputs = [ "bin" "out" "dev" ];

  src = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-hjR8nwqGZvJj/WP4w/5MT5yxvbPsQmDsuvEX0Tfol4c=";
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

  checkInputs = [
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
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
