{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "0.52";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b6fcbc7179c0f09bd99f7f7c42b614bce5f39543fb18b190e408488f987d6b5";
  };

  propagatedBuildInputs = [ moznetwork mozprocess ];

  meta = {
    description = "Mozilla-authored device management";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
