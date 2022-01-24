{ lib
, buildPythonPackage
, fetchPypi
, docutils
, nose
, testtools
}:

buildPythonPackage rec {
  pname = "restructuredtext_lint";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3b10a1fe2ecac537e51ae6d151b223b78de9fafdd50e5eb6b08c243df173c80";
  };

  checkInputs = [ nose testtools ];
  propagatedBuildInputs = [ docutils ];

  checkPhase = ''
    nosetests --nocapture
  '';

  meta = {
    description = "reStructuredText linter";
    homepage = "https://github.com/twolfson/restructuredtext-lint";
    license = lib.licenses.unlicense;
  };
}
