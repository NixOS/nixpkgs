{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, mozversion
, mozrunner
}:

buildPythonPackage rec {
  pname = "marionette_driver";
  version = "3.0.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "99ca2513d4e2ca29a08e550346f23947a50627a2b02f6ad36a4550e779fa0ce8";
  };

  propagatedBuildInputs = [ mozversion mozrunner ]; 

  meta = {
    description = "Mozilla Marionette driver";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Marionette;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
