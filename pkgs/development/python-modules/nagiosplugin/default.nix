{ lib
, buildPythonPackage
, twine
, numpy
, pytest
, fetchPypi
}:

buildPythonPackage rec {
  pname = "nagiosplugin";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vOr67DWfAyOT3dVgrizI0WNhODPsY8k85xifhZBOU9Y=";
  };

  nativeBuildInputs = [ twine ];
  checkInputs = [ pytest numpy ];

  checkPhase = ''
    # this test relies on who, which does not work in the sandbox
    pytest -k "not test_check_users" tests/
  '';

  meta = with lib; {
    description = "A Python class library which helps with writing Nagios (Icinga) compatible plugins";
    homepage =  "https://github.com/mpounsett/nagiosplugin";
    license = licenses.zpl21;
    maintainers = with maintainers; [ symphorien ];
  };
}
