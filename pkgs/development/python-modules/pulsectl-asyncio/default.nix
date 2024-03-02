{ lib
, buildPythonPackage
, fetchFromGitHub
, pulsectl
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pulsectl-asyncio";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhthies";
    repo = "pulsectl-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uc8iUo9THWNPRRsvJxfw++41cnKrANe/Fk6e8bgLSkc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pulsectl
  ];

  # Tests require a running pulseaudio instance
  doCheck = false;

  pythonImportsCheck = [
    "pulsectl_asyncio"
  ];

  meta = with lib; {
    description = "Python bindings library for PulseAudio";
    homepage = "https://github.com/mhthies/pulsectl-asyncio";
    changelog = "https://github.com/mhthies/pulsectl-asyncio/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
