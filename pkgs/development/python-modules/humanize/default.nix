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
  version = "3.2.0";
  pname = "humanize";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "09ph6fd1362xdn2hgwdgh30z0zqjp3bgvr1akyvm36b8jm400sdb";
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
