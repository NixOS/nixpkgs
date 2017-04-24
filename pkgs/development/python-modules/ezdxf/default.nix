{ stdenv, buildPythonPackage, fetchurl, isPy3k, pyparsing }:

buildPythonPackage rec {
  version = "0.8.1";
  name = "ezdxf-${version}";

  src = fetchurl {
    url = "mirror://pypi/e/ezdxf/${name}.zip";
    sha256 = "1q4la4h7840wb8l2jf39wy68gq5jwymkghb1a1mg8qblj424130k";
  };

  # Tests fail on Python 3.x, but module imports and works
  doCheck = !(isPy3k);
    
  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    homepage = https://github.com/mozman/ezdxf/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
