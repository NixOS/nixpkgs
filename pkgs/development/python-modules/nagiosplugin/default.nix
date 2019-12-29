{ lib
, buildPythonPackage
, twine
, numpy
, pytest
, fetchPypi
}:

buildPythonPackage rec {
  pname = "nagiosplugin";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vr3zy0zfvbrqc4nf81zxv4gs2q82sv5sjamdm4573ld529mk2nv";
  };

  nativeBuildInputs = [ twine ];
  checkInputs = [ pytest numpy ];

  checkPhase = ''
    # this test relies on who, which does not work in the sandbox
    pytest -k "not test_check_users" tests/
  '';

  meta = with lib; {
    description = "A Python class library which helps with writing Nagios (Icinga) compatible plugins";
    homepage =  https://github.com/mpounsett/nagiosplugin;
    license = licenses.zpl21;
    maintainers = with maintainers; [ symphorien ];
  };
}
