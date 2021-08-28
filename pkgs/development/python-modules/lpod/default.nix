{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, docutils
, pillow
, isPy3k
}:

buildPythonPackage {
  version = "1.1.7";
  pname = "python-lpod";
  # lpod library currently does not support Python 3.x
  disabled = isPy3k;

  propagatedBuildInputs = [ lxml docutils pillow ];

  src = fetchFromGitHub {
    owner = "lpod";
    repo = "lpod-python";
    rev = "dee32120ee582ff337b0c52a95a9a87cca71fd67";
    sha256 = "1mikvzp27wxkzpr2lii4wg1hhx8h610agckqynvsrdc8v3nw9ciw";
  };

  meta = with lib; {
    homepage = "https://github.com/lpod/lpod-python/";
    description = "Library implementing the ISO/IEC 26300 OpenDocument Format standard (ODF) ";
    license = licenses.gpl3;
  };

}
