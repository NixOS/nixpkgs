{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, pyparsing, pytest }:

buildPythonPackage rec {
  version = "0.9";
  pname = "ezdxf";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    rev = "v${version}";
    sha256 = "1ggimjd9060b696sgzgxy9j9sl45wh9qbxnf0035qclafshprlzl";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest tests integration_tests";

  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    homepage = https://github.com/mozman/ezdxf/;
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
  };
}
