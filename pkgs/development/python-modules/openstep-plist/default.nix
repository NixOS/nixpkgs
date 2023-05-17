{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
, cython
, pythonImportsCheckHook
}:

buildPythonPackage rec {
  pname = "openstep-plist";
  version = "0.3.0.post1";

  src = fetchPypi {
    pname = "openstep_plist";
    inherit version;
    hash = "sha256-GK/z1e3tnr++3+ukRKPASDJGl7+KObsENhwN1Tv+qws=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm cython ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "openstep_plist" ];

  meta = {
    description = "Parser for the 'old style' OpenStep property list format also known as ASCII plist";
    homepage = "https://github.com/fonttools/openstep-plist";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.BarinovMaxim ];
  };
}
