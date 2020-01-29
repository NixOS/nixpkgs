{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "3.0.7";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n7l3drdh3rm3320v98c9hhh37ljk9l861hyw18psca7jdd717n5";
    format = "wheel";
  };

  propagatedBuildInputs = [ mozlog moznetwork mozprocess ];

  meta = {
    description = "Mozilla-authored device management";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
