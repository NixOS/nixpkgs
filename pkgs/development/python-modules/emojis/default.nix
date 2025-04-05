{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  unittestCheckHook,
  pandoc,
  lib,
}:
let
  version = "0.7.0";
in
buildPythonPackage {
  pname = "emojis";
  inherit version;
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
    pandoc
  ];

  preBuild = ''
    make pandoc
  '';

  pythonImportsCheck = [ "emojis" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Convert emoji names to emoji characters";
    homepage = "https://github.com/alexandrevicenzi/emojis";
    changelog = "https://github.com/alexandrevicenzi/emojis/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amadaluzia ];
  };
}
