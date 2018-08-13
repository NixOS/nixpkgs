{ buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.3.0";

  propagatedBuildInputs = [ zope_interface ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8e2253a35f46ae318e65f0e3b51cdce16d4646e284a26f88a2d84b4d2507f81";
  };

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = http://www.zope.org/Products/ZODB;
  };
}
