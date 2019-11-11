{ lib
, buildPythonPackage
, fetchPypi
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "3.0.5";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gpz0y81407pk71p9yzf15kqqk10fcansw8a607488d11m1jn3yf";
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
