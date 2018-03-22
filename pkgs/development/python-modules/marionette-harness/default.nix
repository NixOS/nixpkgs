{ lib
, stdenv
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
  version = "4.3.0";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a98bb65a0c63f60d9e3d7ef21dabc9c29676917dc2ec0d46851a3ed694c820cc";
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
