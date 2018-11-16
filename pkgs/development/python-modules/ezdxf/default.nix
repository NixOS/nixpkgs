{ stdenv, buildPythonPackage, fetchFromGitHub, pyparsing, pytest }:

buildPythonPackage rec {
  version = "0.8.8";
  pname = "ezdxf";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    rev = "v${version}";
    sha256 = "0ap6f6vy71s3y0a048r5ca98i7p8nc9l0mx3mngvvpvjij7j3fcf";
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
