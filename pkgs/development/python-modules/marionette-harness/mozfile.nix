{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mozfile";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5dc835582ea150e35ecd57e9d86cb707d3aa3b2505679db7332326dd49fd6b8";
  };

  propagatedBuildInputs = [ ];

  # mozhttpd -> moznetwork -> mozinfo -> mozfile
  doCheck = false;

  meta = {
    description = "File utilities for Mozilla testing";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
