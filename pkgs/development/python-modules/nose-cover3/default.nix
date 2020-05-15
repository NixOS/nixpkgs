{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "nose-cover3";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1la4hhc1yszjpcchvkqk5xmzlb2g1b3fgxj9wwc58qc549whlcc1";
  };

  propagatedBuildInputs = [ nose ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Coverage 3.x support for Nose";
    homepage = "https://github.com/ask/nosecover3";
    license = licenses.lgpl21;
  };

}
