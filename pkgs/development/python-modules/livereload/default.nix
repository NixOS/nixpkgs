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
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "python-livereload";
    rev = version;
    sha256 = "1alp83h3l3771l915jqa1ylyllad7wxnmblayan0z0zj37jkp9n7";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [ tornado six ];

  nativeCheckInputs = [ nose ];
  # TODO: retry running all tests after v2.6.1
  checkPhase = "NOSE_EXCLUDE=test_watch_multiple_dirs nosetests -s";

  meta = {
    description = "Runs a local server that reloads as you develop";
    homepage = "https://github.com/lepture/python-livereload";
    license = lib.licenses.bsd3;
  };
}
