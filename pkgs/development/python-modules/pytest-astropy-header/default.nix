{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pytestCheckHook,
  numpy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-astropy-header";
  version = "0.2.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d4kRAclLdajKMFRTuHmzGKtgAbNw3wK+LAttG7Mi2xA=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  meta = with lib; {
    description = "Plugin to add diagnostic information to the header of the test output";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
