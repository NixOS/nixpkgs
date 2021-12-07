{ lib, buildPythonPackage, fetchPypi, packaging, pytest, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-snapshot";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf84c88c3e0b4ae08ae797d9ccdc32715b64dd68b2da40f575db56956ed23326";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ packaging ];

  # pypi does not contain tests and GitHub archive is not supported because setuptools-scm can't detect the version
  doCheck = false;
  pythonImportsCheck = [ "pytest_snapshot" ];

  meta = with lib; {
    description = "A plugin to enable snapshot testing with pytest";
    homepage = "https://github.com/joseph-roitman/pytest-snapshot/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
