{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  execnet,
}:

buildPythonPackage rec {
  pname = "pytest-cache";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vnRo7dTT2D8ehElZ/W4/0o53pIFECnEY1DATDqMbB6k=";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ execnet ];

  checkPhase = ''
    py.test
  '';

  # Too many failing tests. Are they maintained?
  doCheck = false;

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://pypi.python.org/pypi/pytest-cache/";
    description = "pytest plugin with mechanisms for caching across test runs";
  };
}
