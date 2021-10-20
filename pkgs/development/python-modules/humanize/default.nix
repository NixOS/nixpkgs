{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, setuptools
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  version = "3.11.0";
  pname = "humanize";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "4160cdc63fcd0daac27d2e1e218a31bb396fc3fe5712d153675d89432a03778f";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ setuptools ];
  checkInputs = [ pytestCheckHook freezegun ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/jmoiron/humanize";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
  };

}
