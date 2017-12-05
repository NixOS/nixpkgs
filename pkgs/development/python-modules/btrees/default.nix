{ stdenv, fetchPypi, buildPythonPackage, persistent, zope_interface, transaction }:

buildPythonPackage rec {
  pname = "BTrees";
  version = "4.4.1";
  name = "${pname}-${version}";

  buildInputs = [ transaction ];
  propagatedBuildInputs = [ persistent zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2738b71693971c1f7502888d649bef270c65f026db731e03d53f1ec4edfe8a3";
  };

  meta = with stdenv.lib; {
    description = "Scalable persistent components";
    homepage = http://packages.python.org/BTrees;
    license = licenses.zpl21;
  };
}
