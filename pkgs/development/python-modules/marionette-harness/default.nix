{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozprofile
, mozversion
, moztest
, manifestparser
, marionette_driver
, browsermob-proxy
, wptserve
}:

buildPythonPackage rec {
  pname = "marionette-harness";
  version = "4.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20c188791e28d586c58acf86ff28cb704c4195a4da6eb10db7b8c6771e3f2983";
  };

  propagatedBuildInputs = [ mozprofile mozversion browsermob-proxy moztest 
    wptserve manifestparser marionette_driver ]; 

  meta = {
    description = "Mozilla Marionette protocol test automation harness";
    homepage = https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
