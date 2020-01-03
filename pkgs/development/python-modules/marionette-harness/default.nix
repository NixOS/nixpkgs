{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
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
  version = "5.0.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "041cd779ae383fb5c56f2bb44824f4e80ba895febd9a3f21570ac274221c82e0";
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
