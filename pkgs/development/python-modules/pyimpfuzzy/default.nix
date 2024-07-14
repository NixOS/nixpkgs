{
  lib,
  buildPythonPackage,
  fetchPypi,
  ssdeep,
  pefile,
}:
buildPythonPackage rec {
  pname = "pyimpfuzzy";
  version = "0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2peW3zAttLBKGXEoY3+EmI8YgvHgj91pu/n9xs+680k=";
  };

  buildInputs = [ ssdeep ];

  propagatedBuildInputs = [ pefile ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pyimpfuzzy" ];

  meta = with lib; {
    description = "Python module which calculates and compares the impfuzzy (import fuzzy hashing)";
    homepage = "https://github.com/JPCERTCC/impfuzzy";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
