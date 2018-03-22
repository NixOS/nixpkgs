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
  version = "6.14";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a401ea5141cdd15d8f047f19a30ccbeabeb0aea079674b684121acddc5dcf810";
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
