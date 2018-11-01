{ stdenv, buildPythonPackage, fetchFromGitHub
, enum-compat
, xorgserver, pytest, i3, python
}:

buildPythonPackage rec {
  pname = "i3ipc";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner  = "acrisci";
    repo   = "i3ipc-python";
    rev    = "v${version}";
    sha256 = "06d7g4d7cnh0vp5diavy3x9wz1w5nwdrb7ipc4g1c3a2wc78862d";
  };

  propagatedBuildInputs = [ enum-compat ];

  checkInputs = [ xorgserver pytest i3 ];

  checkPhase = ''${python.interpreter} run-tests.py'';

  meta = with stdenv.lib; {
    description = "An improved Python library to control i3wm";
    homepage    = https://github.com/acrisci/i3ipc-python;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ vanzef ];
  };
}
