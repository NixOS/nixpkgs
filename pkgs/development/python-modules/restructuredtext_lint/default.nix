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
  version = "1.1.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c48ca9a84c312b262809f041fe47dcfaedc9ee4879b3e1f9532f745c182b4037";
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