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
  version = "3.13.1";
  pname = "humanize";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "12f113f2e369dac7f35d3823f49262934f4a22a53a6d3d4c86b736f50db88c7b";
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
