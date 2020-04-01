{ lib
, buildPythonPackage
, fetchPypi
, greenlet
, pytest
, decorator
}:

buildPythonPackage rec {
  pname = "pytest-twisted";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "bb9af117c5c6063d9ef20ffdf2fa297caaf57de5a687e4d3607db7b0a6f74fea";
  };

  propagatedBuildInputs = [ greenlet pytest decorator ];

  meta = with lib; {
    description = "A twisted plugin for py.test";
    homepage = "https://github.com/pytest-dev/pytest-twisted";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
