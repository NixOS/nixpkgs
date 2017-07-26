{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozversion
, mozrunner
}:

buildPythonPackage rec {
  pname = "marionette_driver";
  version = "2.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0phlb4r6xf3yv1z23kn6paxkq6fvfywj2h4gcbavg4w6jd63vd5z";
  };

  propagatedBuildInputs = [ mozversion mozrunner ]; 

  meta = {
    description = "Mozilla Marionette driver";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Marionette";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
