{ lib
, buildPythonPackage
, fetchPypi
, greenlet
, pytest
, decorator
}:

buildPythonPackage rec {
  pname = "pytest-twisted";
  version = "1.13.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "cee2320becc5625050ab221b8f38533e636651a24644612f4726891fdf1f1847";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ greenlet decorator ];

  meta = with lib; {
    description = "A twisted plugin for py.test";
    homepage = "https://github.com/pytest-dev/pytest-twisted";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
