{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorful";
  version = "0.5.5";

  # No tests in the Pypi package.
  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-fgxbj1WE9JcGt+oEcBguL0wQEWIn5toRTLWsvCFO3k8=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Terminal string styling done right, in Python.";
    homepage = "https://github.com/timofurrer/colorful";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
