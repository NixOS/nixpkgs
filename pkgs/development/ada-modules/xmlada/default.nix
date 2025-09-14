{
  stdenv,
  lib,
  fetchFromGitHub,
  gnat,
  # use gprbuild-boot since gprbuild proper depends
  # on this xmlada derivation.
  gprbuild-boot,
}:

stdenv.mkDerivation rec {
  pname = "xmlada";
  version = "25.0.0";

  src = fetchFromGitHub {
    name = "xmlada-${version}-src";
    owner = "AdaCore";
    repo = "xmlada";
    rev = "v${version}";
    sha256 = "sha256-UMJiXSHMS8+X5gyV1nmC29gF71BFnz7LNPQnwUMD3Yg=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild-boot
  ];

  meta = {
    description = "XML/Ada: An XML parser for Ada";
    homepage = "https://github.com/AdaCore/xmlada";
    maintainers = [ lib.maintainers.sternenseemann ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
}
