{ lib
, buildPythonPackage
, fetchPypi
, docutils
, nose
, testtools
}:

buildPythonPackage rec {
  pname = "restructuredtext_lint";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "470e53b64817211a42805c3a104d2216f6f5834b22fe7adb637d1de4d6501fb8";
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
