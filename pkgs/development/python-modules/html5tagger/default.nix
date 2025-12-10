{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "html5tagger";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "html5tagger";
    rev = "v${version}";
    hash = "sha256-Or0EizZC9FMjTcbgecDvgGB09KNGyxHreSDojgB7ysg=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "html5tagger" ];

  meta = {
    description = "Create HTML documents from Python";
    homepage = "https://github.com/sanic-org/html5tagger";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
}
