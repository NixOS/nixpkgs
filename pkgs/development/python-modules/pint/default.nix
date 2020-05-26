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
  version = "0.11";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    sha256 = "0kfgnmcs6z9ndhzvwg2xzhpwxgyyagdsdz5dns1jy40fa1q113rh";
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
