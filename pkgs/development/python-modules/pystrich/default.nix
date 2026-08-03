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
  version = "0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mmulqueen";
    repo = "pyStrich";
    tag = version;
    hash = "sha256-pdh41B/eGcyO4fZRRyNc0ZBvTmZqWq4Wao4K19/e4Dk=";
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
