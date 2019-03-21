{ lib
, buildPythonPackage
, fetchPypi
, isPy37
, docutils
, nose
, testtools
}:

buildPythonPackage rec {
  pname = "restructuredtext_lint";
  version = "1.2.2";

  # https://github.com/twolfson/restructuredtext-lint/pull/47
  disabled = isPy37;

  src = fetchPypi {
    inherit pname version;
    sha256 = "82880a8de8a41bfc84f533744091b1ead8e2ab9ad6c0a3f60f4750ef6c802350";
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
