{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyasyncore";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "pyasyncore";
    tag = "v${version}";
    hash = "sha256-ptqOsbkY7XYZT5sh6vctfxZ7BZPX2eLjo6XwZfcmtgk=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "asyncore" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Make asyncore available for Python 3.12 onwards";
    homepage = "https://github.com/simonrob/pyasyncore";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
