{ stdenv, fetchPypi, buildPythonPackage, persistent, zope_interface, transaction }:

buildPythonPackage rec {
  pname = "BTrees";
  version = "4.5.0";
  name = "${pname}-${version}";

  buildInputs = [ transaction ];
  propagatedBuildInputs = [ persistent zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "46b02cb69b26a5238db771ea1955b503df73ecf254bb8063af4c61999fc75b5c";
  };

  meta = with stdenv.lib; {
    description = "Scalable persistent components";
    homepage = http://packages.python.org/BTrees;
    license = licenses.zpl21;
  };
}
