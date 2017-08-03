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
  version = "4.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0726zm09nwh4kkd4xirva4596svlifkkpbaywlmq2yb6ayk7d4vl";
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
