{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyasyncore";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "pyasyncore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gpmsawbTf59EchoKixWw2wcBoOFElPDLg9zylvhA04U=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "asyncore" ];

  doCheck = false; # no tests

  meta = {
    description = "Make asyncore available for Python 3.12 onwards";
    homepage = "https://github.com/simonrob/pyasyncore";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
})
