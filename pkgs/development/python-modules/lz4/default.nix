{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "lz4";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af46e2e5c002b3fbffa2ad69289aa61e46cab1a87c1d85bda44e822a1634defa";
  };

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Compression library";
    homepage = https://github.com/python-lz4/python-lz4;
    license = licenses.bsd3;
  };

}
