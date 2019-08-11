{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, mozversion
, mozrunner
}:

buildPythonPackage rec {
  pname = "marionette_driver";
  version = "2.7.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15c77ba548847dc05ce1b663a22c3324623f217dce5a859c3aaced31fd16707b";
  };

  propagatedBuildInputs = [ mozversion mozrunner ]; 

  meta = {
    description = "Mozilla Marionette driver";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Marionette;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
