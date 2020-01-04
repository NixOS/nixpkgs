{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "3.0.6";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gw2lk16fz2n1953i29hgw47s2h0c6z911zzg8am1in8qq2318xv";
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
