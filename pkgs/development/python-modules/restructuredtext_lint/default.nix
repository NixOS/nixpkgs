{ lib
, buildPythonPackage
, fetchPypi
, docutils
, nose
, stdenv
, flake8
, pyyaml
, testtools
}:

buildPythonPackage rec {
  pname = "restructuredtext_lint";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82880a8de8a41bfc84f533744091b1ead8e2ab9ad6c0a3f60f4750ef6c802350";
  };

  checkInputs = [ nose flake8 pyyaml testtools ];
  propagatedBuildInputs = [ docutils ];

  checkPhase = ''
     ${stdenv.shell} test.sh
  '';

  meta = {
    description = "reStructuredText linter";
    homepage = https://github.com/twolfson/restructuredtext-lint;
    license = lib.licenses.unlicense;
  };
}