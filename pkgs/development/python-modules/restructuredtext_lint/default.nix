{ lib
, buildPythonPackage
, fetchPypi
, docutils
, nose
, testtools
}:

buildPythonPackage rec {
  pname = "restructuredtext_lint";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97b3da356d5b3a8514d8f1f9098febd8b41463bed6a1d9f126cf0a048b6fd908";
  };

  checkInputs = [ nose testtools ];
  propagatedBuildInputs = [ docutils ];

  checkPhase = ''
    nosetests --nocapture
  '';

  meta = {
    description = "reStructuredText linter";
    homepage = https://github.com/twolfson/restructuredtext-lint;
    license = lib.licenses.unlicense;
  };
}
