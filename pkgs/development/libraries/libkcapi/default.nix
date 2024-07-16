{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, buildPackages
  # libkcapi offers multiple tools. They can be disabled for minimization.
, kcapi-test ? true
, kcapi-speed ? true
, kcapi-hasher ? true
, kcapi-rngapp ? true
, kcapi-encapp ? true
, kcapi-dgstapp ? true
}:

stdenv.mkDerivation rec {
  pname = "libkcapi";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "libkcapi";
    rev = "v${version}";
    hash = "sha256-xOI29cjhUGUeHLaYIrPA5ZwwCE9lBdZG6kaW0lo1uL8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # libkcapi looks also for a host c compiler when cross-compiling
  # otherwise you obtain following error message:
  # "error: no acceptable C compiler found in $PATH"
  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  enableParallelBuilding = true;

  configureFlags =
    lib.optional kcapi-test "--enable-kcapi-test" ++
    lib.optional kcapi-speed "--enable-kcapi-speed" ++
    lib.optional kcapi-hasher "--enable-kcapi-hasher" ++
    lib.optional kcapi-rngapp "--enable-kcapi-rngapp" ++
    lib.optional kcapi-encapp "--enable-kcapi-encapp" ++
    lib.optional kcapi-dgstapp "--enable-kcapi-dgstapp"
  ;

  meta = {
    homepage = "http://www.chronox.de/libkcapi.html";
    description = "Linux Kernel Crypto API User Space Interface Library";
    license = with lib.licenses; [ bsd3 gpl2Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orichter thillux ];
  };
}
