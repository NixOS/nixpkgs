{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pythonOlder
, funcsigs
, setuptools_scm
# Check Inputs
, pytestCheckHook
, numpy
, matplotlib
, uncertainties
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.14";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    sha256 = "0wkzb7g20wzpqr3xaqpq96dlfv6irw202icsz81ys8npp7mm194s";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    setuptools_scm
  ] ++ lib.optional isPy27 funcsigs;

  # Test suite explicitly requires pytest
  checkInputs = [
    pytestCheckHook
    numpy
    matplotlib
    uncertainties
  ];
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = [ maintainers.costrouc ];
  };

}
