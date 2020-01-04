{ lib
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
  version = "7.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04s6w0sp83bn3c6ym75rnlpmcy3yr7d35jxkxhgzmy75gbcps7bi";
  };

  propagatedBuildInputs = [ mozdevice mozfile mozinfo mozlog mozprocess
    mozprofile mozcrash ];

  meta = {
    description = "Mozilla application start/stop helpers";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
