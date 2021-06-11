{ buildPythonPackage, fetchPypi, atpublic, zope_interface, nose2 }:

buildPythonPackage rec {
  pname = "flufl.bounce";
  version = "3.0.2";

  buildInputs = [ nose2 ];
  propagatedBuildInputs = [ atpublic zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "5014b23248fce72b13143c32da30073e6abc655b963e7739575608280c52c9a7";
  };
}
