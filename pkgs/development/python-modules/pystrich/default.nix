{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pillow,
  typing-extensions,
  pytestCheckHook,
  ezdxf,
  fonttools,
  hypothesis,
  zxing-cpp,
  dmtx-utils,
  librsvg,
  ghostscript,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pystrich";
  version = "0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mmulqueen";
    repo = "pyStrich";
    tag = version;
    hash = "sha256-08IKFJfcK0I+phUejUY7FHh2a7efR+UKrj+tsKEwSJ4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pillow
    typing-extensions
  ];

  optional-dependencies = {
    png = [ pillow ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    ezdxf
    fonttools
    hypothesis
    zxing-cpp
    dmtx-utils
    librsvg
    ghostscript
  ];

  pythonImportsCheck = [ "pystrich" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pure-Python module to generate 1D and 2D barcodes";
    homepage = "https://github.com/mmulqueen/pyStrich";
    changelog = "https://github.com/mmulqueen/pyStrich/releases/tag/${version}";
    license = lib.licenses.asl20;
    mainProgram = "pystrich";
    maintainers = with lib.maintainers; [ mmulqueen ];
  };
}
