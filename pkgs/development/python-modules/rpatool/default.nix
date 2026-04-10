{
  lib,
  fetchFromGitea,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rpatool";
  version = "1.0.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "shiz";
    repo = "rpatool";
    tag = "v${version}";
    hash = "sha256-AHFL0pahwS8/MH13NgPiKtKAP+nBqfbcUVWzV+Jdco0=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  pythonImportsCheck = [ "rpatool" ];

  meta = {
    homepage = "https://codeberg.org/shiz/rpatool";
    description = "Simple tool allowing you to create, modify and extract Ren'Py Archive (.rpa/.rpi) files";
    mainProgram = "rpatool";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
}
