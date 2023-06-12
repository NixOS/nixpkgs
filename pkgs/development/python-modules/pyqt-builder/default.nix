{ lib, fetchPypi, buildPythonPackage, packaging, sip, setuptools }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.15.1";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    hash = "sha256-or08+/lS6VkUHf5VtEtFGqlFyokW0bdzhQuy+cD6KYU=";
  };

  propagatedBuildInputs = [ packaging sip setuptools ];

  pythonImportsCheck = [ "pyqtbuild" ];

  # There aren't tests
  doCheck = false;

  meta = with lib; {
    description = "PEP 517 compliant build system for PyQt";
    homepage = "https://pypi.org/project/PyQt-builder/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
