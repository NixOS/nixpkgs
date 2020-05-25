{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, pyparsing, pytest }:

buildPythonPackage rec {
  version = "0.11";
  pname = "ezdxf";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    rev = "v${version}";
    sha256 = "167iw1j1c6195bwv6i8z1m7s0i27r0y0acxd2w76hvnq3a72jbsd";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest tests integration_tests";

  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    homepage = "https://github.com/mozman/ezdxf/";
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
  };
}
