{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zscroll";
  version = "2.0.1";
  format = "setuptools";

  # don't prefix with python version
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "zscroll";
    rev = finalAttrs.version;
    sha256 = "sha256-gEluWzCbztO4N1wdFab+2xH7l9w5HqZVzp2LrdjHSRM=";
  };

  doCheck = false;

  propagatedBuildInputs = [ python3 ];

  meta = {
    description = "Text scroller for use with panels and shells";
    mainProgram = "zscroll";
    homepage = "https://github.com/noctuid/zscroll";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
