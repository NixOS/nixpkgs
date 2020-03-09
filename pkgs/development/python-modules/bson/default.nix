{ stdenv
, buildPythonPackage
, fetchPypi
, python-dateutil
}:

buildPythonPackage rec {
  pname = "bson";
  version = "0.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n01axc6vnszmbz1mx64d2blrb78hbcvlnl4v4a5h39mzb8nv844";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/py-bson/bson";
    description = "Independent BSON codec for Python that doesn’t depend on MongoDB.";
    license = licenses.bsd3;
    maintainers = [ maintainers.GuillaumeDesforges ];
  };
}