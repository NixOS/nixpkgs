{
  lib,
  stdenv,
  tcl,
  fetchFromGitHub,
  autoreconfHook,
  tk,
  libGL,
}:

tcl.mkTclDerivation {
  pname = "tkgl";
  version = "1.2.1-unstable-2025-06-01";

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "TkGL";
    rev = "45bf16e6c28a070c70fc9a0eb8c47a0b6ff8a2e3";
    hash = "sha256-AA5LZGhMTWmTZqI/wtycUYLsUe9BwO3voGMS7vGlCM0=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure.ac \
      --replace-fail "-arch x86_64 -arch arm64" ""
  '';

  configureFlags = [
    "--with-tk=${lib.getLib tk}/lib"
    "--with-tkinclude=${lib.getDev tk}/include"
  ];

  installTargets = [
    "install-lib-binaries"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    tk
    libGL
  ];

  meta = {
    description = "OpenGL drawing surface for Tk 8 and 9";
    homepage = "https://github.com/3-manifolds/TkGL";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
}
