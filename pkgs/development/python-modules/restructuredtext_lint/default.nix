{ lib
, buildPythonPackage
, fetchPypi
, docutils
, nose
, testtools
}:

buildPythonPackage rec {
  pname = "restructuredtext_lint";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GyNcDJIjQatsUwOQiS656S+QubdQRgY+BHys+w8FDEU=";
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
