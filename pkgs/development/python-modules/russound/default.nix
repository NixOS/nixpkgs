{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "russound";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laf";
    repo = "russound";
    tag = version;
    hash = "sha256-iAhHOZwgaLhgkN/oW3Oz9bazyoqlP8GIsaXpqyXs3/Y=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests require actual hardware to connect to
  doCheck = false;

  pythonImportsCheck = [ "russound" ];

  meta = {
    description = "Python API for select Russound RNET commands to provide Russound support within home-assistant.io";
    homepage = "https://github.com/laf/russound";
    changelog = "https://github.com/laf/russound/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
