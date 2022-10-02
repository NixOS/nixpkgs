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
  version = "0.3.0";

  src = fetchPypi {
    pname = "openstep_plist";
    inherit version;
    sha256 = "sha256-KO4sGKjod5BwUFQ1MU2S1dG0DyiJ06mdroMbRDsugBk=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm cython ];
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "openstep_plist" ];

  meta = {
    description = "Parser for the 'old style' OpenStep property list format also known as ASCII plist";
    homepage = "https://github.com/fonttools/openstep-plist";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.BarinovMaxim ];
  };
}
