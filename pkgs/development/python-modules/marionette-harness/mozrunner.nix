{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozdevice
, mozfile
, mozinfo
, mozlog
, mozprocess
, mozprofile
, mozcrash
}:

buildPythonPackage rec {
  pname = "mozrunner";
  version = "6.13";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d5k3a0w1iyyk6l28l65j47grq87zd207h369x4vahq02nrx2g6l";
  };

  propagatedBuildInputs = [ mozdevice mozfile mozinfo mozlog mozprocess
    mozprofile mozcrash ];

  meta = {
    description = "Mozilla application start/stop helpers";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
