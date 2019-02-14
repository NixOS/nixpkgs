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
  version = "7.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6fdeec757f0660abf2e31d772e65602aac1c78c96002c11341a5e0d8650b3f70";
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
