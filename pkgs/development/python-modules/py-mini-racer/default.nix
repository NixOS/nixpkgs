{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "py-mini-racer";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sqreen";
    repo = "PyMiniRacer";
    rev = "v${version}";
    sha256 = "sha256-r6ghH1uPbnM4cruxgcOkHv3HsC29p3fILtH3Mzpy8yQ=";
  };

  doCheck = false;

  meta = with lib; {
    description = "PyMiniRacer is a V8 bridge in Python";
    homepage = "https://github.com/sqreen/PyMiniRacer";
    license = licenses.isc;
    maintainers = with maintainers; [ baksa ];
  };
}
