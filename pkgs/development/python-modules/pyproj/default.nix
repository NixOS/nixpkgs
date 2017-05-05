{ lib
, buildPythonPackage
, fetchPypi
, proj
, python
}:

buildPythonPackage rec {
  pname = "pyproj";
  version = "1.9.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53fa54c8fa8a1dfcd6af4bf09ce1aae5d4d949da63b90570ac5ec849efaf3ea8";
  };

  buildInputs = [ proj ];

  # Could not get tests working
  doCheck = false;

  meta = {
    description = "Python interface to PROJ.4 library";
    homepage = http://github.com/jswhit/pyproj;
    license = with lib.licenses; [ isc ];
  };
}
