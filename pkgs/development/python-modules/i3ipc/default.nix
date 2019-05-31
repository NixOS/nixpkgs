{ stdenv, buildPythonPackage, fetchFromGitHub
, enum-compat
, xorgserver, pytest, i3, python
}:

buildPythonPackage rec {
  pname = "i3ipc";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner  = "acrisci";
    repo   = "i3ipc-python";
    rev    = "v${version}";
    sha256 = "0sb525wvwcnikjaqzha94xr97r1gjys30csmaj17swlxgyczxvq5";
  };

  propagatedBuildInputs = [ enum-compat ];

  checkInputs = [ xorgserver pytest i3 ];

  checkPhase = ''${python.interpreter} run-tests.py'';

  meta = with stdenv.lib; {
    description = "An improved Python library to control i3wm and sway";
    homepage    = https://github.com/acrisci/i3ipc-python;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ vanzef ];
  };
}
