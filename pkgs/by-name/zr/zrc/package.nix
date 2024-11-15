{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
}:

stdenv.mkDerivation {
  pname = "zrc";
  version = "2.0-unstable-2024-11-10";

  src = fetchFromGitHub {
    owner = "Edd12321";
    repo = "zrc";
    rev = "bee7c896bcc16a15f24396d8c584d849a62c933a";
    hash = "sha256-ZB8mKR69kZ9HeIoa/+xseB6/0iOGVLgQggoEWXFffuY=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "UNIX shell and scripting language with syntax similar to Tcl";
    homepage = "https://github.com/Edd12321/zrc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "zrc";
    platforms = lib.platforms.all;
  };
}
