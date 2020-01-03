{ lib
, buildPythonPackage
, fetchPypi
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "3.0.6";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cbeb4558f952cb08f53c4b57a405981b5683f38df0b293f0e7d20b6f4c17d84";
    format = "wheel";
  };

  propagatedBuildInputs = [ moznetwork mozprocess ];

  meta = {
    description = "Mozilla-authored device management";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
