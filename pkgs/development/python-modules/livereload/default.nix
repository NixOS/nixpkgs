{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, django
, tornado
, six
}:

buildPythonPackage rec {
  pname = "livereload";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "python-livereload";
    rev = "v${version}";
    sha256 = "15v2a0af897ijnsfjh2r8f7l5zi5i2jdm6z0xzlyyvp9pxd6mpfm";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [ tornado six ];

  checkInputs = [ nose ];
  # TODO: retry running all tests after v2.6.1
  checkPhase = "NOSE_EXCLUDE=test_watch_multiple_dirs nosetests -s";

  meta = {
    description = "Runs a local server that reloads as you develop";
    homepage = "https://github.com/lepture/python-livereload";
    license = lib.licenses.bsd3;
  };
}
