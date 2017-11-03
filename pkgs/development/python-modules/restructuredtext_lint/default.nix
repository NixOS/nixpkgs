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
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "167e8adaa5bdc30531ee91760d6c216b306a8a3372aad34b1f72d8adcc5e011e";
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