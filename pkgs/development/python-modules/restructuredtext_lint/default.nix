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
  version = "1.1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9201d354e22c27be61cf6d8212da6e10c875eec7ec8d1bdb1067b2a5ba931637";
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