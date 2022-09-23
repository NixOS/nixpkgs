{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, pyparsing, pytest }:

buildPythonPackage rec {
  version = "0.12";
  pname = "ezdxf";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    rev = "v${version}";
    sha256 = "1flcq96ljk5wqrmgsb4acflqzkg7rhlaxz0j5jxky9za0mj1x6dq";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest tests integration_tests";

  propagatedBuildInputs = [ pyparsing ];

  meta = with lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    homepage = "https://github.com/mozman/ezdxf/";
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
  };
}
