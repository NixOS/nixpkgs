{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytestCheckHook
, psutil
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-openfiles";
  version = "0.5.0";
  format = "setuptools";
  disabled = isPy27; # abandoned

  src = fetchPypi {
    inherit pname version;
    sha256 = "179c2911d8aee3441fee051aba08e0d9b4dab61b829ae4811906d5c49a3b0a58";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    psutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin for detecting inadvertent open file handles";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
