{ stdenv, buildPythonPackage, fetchFromGitHub, pyparsing, pytest }:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "ezdxf";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    rev = "v${version}";
    sha256 = "1c20j96n3rsgzaakfjl0wnydaj2qr69gbnnjs6mfa1hz2fjqri22";
  };

  buildInputs = [ pytest ];
  checkPhase = "python -m unittest discover -s tests";

  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    homepage = https://github.com/mozman/ezdxf/;
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
  };
}
