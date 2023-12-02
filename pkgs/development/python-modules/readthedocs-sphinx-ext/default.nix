{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytest
, mock
, sphinx
}:

buildPythonPackage rec {
  pname = "readthedocs-sphinx-ext";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZYPCZ5GlhT7p5Xzp24ZOL7BoCLpHD4BddNU/xQgR4BI=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytest mock sphinx ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Sphinx extension for Read the Docs overrides";
    homepage = "https://github.com/rtfd/readthedocs-sphinx-ext";
    license = licenses.mit;
  };
}
