{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nodejs
}:

buildPythonPackage rec {
  pname = "pscript";
  version = "0.7.7";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "flexxui";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AhVI+7FiWyH+DfAXnau4aAHJAJtsWEpmnU90ey2z35o=";
  };

  checkInputs = [
    pytestCheckHook
    nodejs
  ];

  preCheck = ''
    # do not execute legacy tests
    rm -rf pscript_legacy
  '';

  meta = with lib; {
    description = "Python to JavaScript compiler";
    license = licenses.bsd2;
    homepage = "https://pscript.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}



