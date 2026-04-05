{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unixodbc";
  version = "2.3.14";

  src = fetchFromGitHub {
    owner = "lurcher";
    repo = "unixODBC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2WhUnpiNTtsoOJ4rvdxaadcW1ROWfdoSVA8Crj8rpo8=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--disable-gui"
    "--sysconfdir=/etc"
  ];

  meta = {
    changelog = "https://github.com/lurcher/unixODBC/releases/tag/v${finalAttrs.version}";
    description = "ODBC driver manager for Unix";
    homepage = "https://www.unixodbc.org/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
})
