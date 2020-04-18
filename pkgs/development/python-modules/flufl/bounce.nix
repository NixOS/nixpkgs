{ buildPythonPackage, fetchPypi, atpublic, zope_interface, nose2 }:

buildPythonPackage rec {
  pname = "flufl.bounce";
  version = "3.0";

  buildInputs = [ nose2 ];
  propagatedBuildInputs = [ atpublic zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k5kjqa3x6gvwwxyzb2vwi1g1i6asm1zw5fivylxz3d583y4kid2";
  };
}
