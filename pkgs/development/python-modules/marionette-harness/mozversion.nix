{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozdevice
}:

buildPythonPackage rec {
  pname = "mozversion";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65f41d7dc14002f83d8f147c82ca34f7213ad07065d250939daaeeb3787dc0fa";
  };

  propagatedBuildInputs = [ mozlog mozdevice ];

  meta = {
    description = "Application version information library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
