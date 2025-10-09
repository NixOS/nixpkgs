{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openmp,
}:

stdenv.mkDerivation {
  pname = "vid.stab";
  version = "1.1.1-unstable-2025-08-21";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = "vid.stab";
    rev = "4bd81e3cdd778e2e0edc591f14bba158ec40cfa1";
    hash = "sha256-imSy1ywpGWbghP65NoPgUJBJmHUY5OsLWmIXk6Q1MQ4=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals stdenv.cc.isClang [ openmp ];

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required (VERSION 2.8.5)' \
        'cmake_minimum_required (VERSION 3.10)'
  '';

  meta = with lib; {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
