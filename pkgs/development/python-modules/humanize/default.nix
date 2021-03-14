{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools_scm
, setuptools
, pytestCheckHook
, freezegun
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "humanize";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd3eb915310335c63a54d4507289ecc7b3a7454cd2c22ac5086d061a3cbfd592";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ setuptools ];
  checkInputs = [ pytestCheckHook freezegun ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/jmoiron/humanize";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
  };

}
