{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "datadiff";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f1402701063998f6a70609789aae8dc05703f3ad0a34882f6199653654c55543";
  };

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "DataDiff";
    homepage = https://sourceforge.net/projects/datadiff/;
    license = licenses.asl20;
  };

}
