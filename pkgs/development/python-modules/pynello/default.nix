{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  requests,
  requests-oauthlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "pynello";
  version = "2.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "pynello";
    rev = finalAttrs.version;
    hash = "sha256-sUy37sEPEMyFYFVBzFVdcg31nZAyC+Ricm4LqxmjuQQ=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynello" ];

  meta = {
    description = "Python library for nello.io intercoms";
    mainProgram = "nello";
    homepage = "https://github.com/pschmitt/pynello";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
