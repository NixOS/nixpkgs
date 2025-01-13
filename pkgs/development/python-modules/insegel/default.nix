{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
}:

buildPythonPackage rec {
  pname = "insegel";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d055dd64f6eb335580a485271511ba2f4e3b5e315f48f827f58da3cace4b4ae";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "insegel" ];

  meta = with lib; {
    homepage = "https://github.com/autophagy/insegel";
    description = "Monochrome 2 column Sphinx theme";
    license = licenses.mit;
    maintainers = with maintainers; [ autophagy ];
  };
}
