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
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4e3d532d1d7eb34b6332e0568612ebac3f56da849894005b3dbe68968e5d292";
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
