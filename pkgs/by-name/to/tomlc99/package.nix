{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "tomlc99";
  version = "0.pre+date=2022-04-04";

  src = fetchFromGitHub {
    owner = "cktan";
    repo = "tomlc99";
    rev = "4e7b082ccc44316f212597ae5b09a35cf9329e69";
    hash = "sha256-R9OBMG/aUa80Qw/zqaks63F9ybQcThfOYRsHP4t1Gv8=";
  };

  dontConfigure = true;

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "https://github.com/cktan/tomlc99";
    description = "TOML v1.0.0-compliant library written in C99";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
