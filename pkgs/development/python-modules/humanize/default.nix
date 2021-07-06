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
  version = "3.9.0";
  pname = "humanize";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "892a5b7b87763c4c6997a58382c2b1f4614048a2e01c23ef1bb0456e6f9d4d5d";
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
