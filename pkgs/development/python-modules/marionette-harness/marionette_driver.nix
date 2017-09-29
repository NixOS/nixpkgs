{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, mozversion
, mozrunner
}:

buildPythonPackage rec {
  pname = "marionette_driver";
  version = "2.3.0";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ab9xxsp0zvckf32k84n52hpibw2c62sa2pmx821d3q0d67yv2vv";
  };

  propagatedBuildInputs = [ mozversion mozrunner ]; 

  meta = {
    description = "Mozilla Marionette driver";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Marionette;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
