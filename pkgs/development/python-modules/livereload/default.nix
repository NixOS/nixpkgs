{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, django
, tornado
, six
, pytest
}:

buildPythonPackage rec {
  pname = "livereload";
  version = "2.5.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "python-livereload";
    rev = "v${version}";
    sha256 = "1irs59wqmffp8q4l9fh7givs05mamlgm5n7ga49gwxp5imwrdzba";
  };

  buildInputs = [ nose django ];

  propagatedBuildInputs = [ tornado six ];

  checkInputs = [ pytest ];
  checkPhase = "pytest tests";

  meta = {
    description = "Runs a local server that reloads as you develop";
    homepage = "https://github.com/lepture/python-livereload";
    license = lib.licenses.bsd3;
  };
}
