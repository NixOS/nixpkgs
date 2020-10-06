{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorful";
  version = "0.5.4";

  # No tests in the Pypi package.
  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fcz5v8b318a3dsdha4c874jsf3wmcw3f25bv2csixclyzacli98";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Terminal string styling done right, in Python.";
    homepage = "https://github.com/timofurrer/colorful";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
