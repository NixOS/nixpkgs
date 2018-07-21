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
  version = "4.5.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "241c7f6032d01b0d78f5c0d13ea691935ddce9f8fce991319cc4fe860d61a7c4";
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
