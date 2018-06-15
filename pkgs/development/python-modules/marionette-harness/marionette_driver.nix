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
  version = "2.5.0";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0axhdin9ys3i9lnwqqqw87wap9000bk6cdgrzpd2gqricc7l3v65";
  };

  propagatedBuildInputs = [ mozversion mozrunner ]; 

  meta = {
    description = "Mozilla Marionette driver";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Marionette;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
