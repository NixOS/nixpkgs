{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, importlib-metadata
, packaging
# Check Inputs
, pytestCheckHook
, numpy
, matplotlib
, uncertainties
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.18";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    sha256 = "8c4bce884c269051feb7abc69dbfd18403c0c764abc83da132e8a7222f8ba801";
  };

  disabled = pythonOlder "3.6";

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ packaging ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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
