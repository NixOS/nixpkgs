{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "zscroll";
  version = "2.0.1";

  # don't prefix with python version
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "zscroll";
    rev = version;
    sha256 = "sha256-gEluWzCbztO4N1wdFab+2xH7l9w5HqZVzp2LrdjHSRM=";
  };

  doCheck = false;

  propagatedBuildInputs = [ python3 ];

  meta = with lib; {
    description = "Text scroller for use with panels and shells";
    mainProgram = "zscroll";
    homepage = "https://github.com/noctuid/zscroll";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
