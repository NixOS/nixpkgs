{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  unittestCheckHook,
  pkgs,
  lib,
}:

buildPythonPackage rec {
  pname = "emojis";
  version = "0.7.0";
  pyproject = true;

  build-system = [ setuptools ];

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "alexandrevicenzi";
    repo = "emojis";
    tag = "v${version}";
    hash = "sha256-rr/BM39U1j8EL8b/YojclI4h0NnOCdoMlecR/1f9ISg=";
  };

  nativeBuildInputs = [
    pkgs.pandoc
  ];

  preBuild = ''
    make pandoc
  '';

  pythonImportsCheck = [ "emojis" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Convert emoji names to emoji characters";
    homepage = "https://github.com/alexandrevicenzi/emojis";
    changelog = "https://github.com/alexandrevicenzi/emojis/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amadaluzia ];
  };
}
