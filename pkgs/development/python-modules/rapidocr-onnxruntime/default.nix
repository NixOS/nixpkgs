{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  fetchzip,
  substitute,
  pytestCheckHook,

  setuptools,
  pyclipper,
  opencv-python,
  numpy,
  six,
  shapely,
  pyyaml,
  pillow,
  onnxruntime,
}:
let
  version = "1.3.24";

  src = fetchFromGitHub {
    owner = "RapidAI";
    repo = "RapidOCR";
    rev = "refs/tags/v${version}";
    hash = "sha256-+iY+/IdOgsn+LPZQ4Kdzxuh31csQ7dyh5Zf552ne3N0=";
  };

  models =
    fetchzip {
      url = "https://github.com/RapidAI/RapidOCR/releases/download/v1.1.0/required_for_whl_v1.3.0.zip";
      hash = "sha256-j/0nzyvu/HfNTt5EZ+2Phe5dkyPOdQw/OZTz0yS63aA=";
      stripRoot = false;
    }
    + "/required_for_whl_v1.3.0/resources/models";
in
buildPythonPackage {
  pname = "rapidocr-onnxruntime";
  inherit version src;
  pyproject = true;

  sourceRoot = "${src.name}/python";

  # HACK:
  # Upstream uses a very unconventional structure to organize the packages, and we have to coax the
  # existing infrastructure to work with it.
  # See https://github.com/RapidAI/RapidOCR/blob/02829ef986bc2a5c4f33e9c45c9267bcf2d07a1d/.github/workflows/gen_whl_to_pypi_rapidocr_ort.yml#L80-L92
  # for the "intended" way of building this package.

  # The setup.py supplied by upstream tries to determine the current version by
  # fetching the latest version of the package from PyPI, and then bumping the version number.
  # This is not allowed in the Nix build environment as we do not have internet access,
  # hence we patch that out and get the version from the build environment directly.
  patches = [
    (substitute {
      src = ./setup-py-override-version-checking.patch;
      substitutions = [
        "--subst-var-by"
        "version"
        version
      ];
    })
  ];

  postPatch = ''
    mv setup_onnxruntime.py setup.py
    mkdir -p rapidocr_onnxruntime/models

    ln -s ${models}/* rapidocr_onnxruntime/models

    # Magic patch from upstream - what does this even do??
    echo "from .rapidocr_onnxruntime.main import RapidOCR, VisRes" > __init__.py
  '';

  # Upstream expects the source files to be under rapidocr_onnxruntime/rapidocr_onnxruntime
  # instead of rapidocr_onnxruntime for the wheel to build correctly.
  preBuild = ''
    mkdir rapidocr_onnxruntime_t
    mv rapidocr_onnxruntime rapidocr_onnxruntime_t
    mv rapidocr_onnxruntime_t rapidocr_onnxruntime
  '';

  # Revert the above hack
  postBuild = ''
    mv rapidocr_onnxruntime rapidocr_onnxruntime_t
    mv rapidocr_onnxruntime_t/* .
  '';

  build-system = [ setuptools ];

  dependencies = [
    pyclipper
    opencv-python
    numpy
    six
    shapely
    pyyaml
    pillow
    onnxruntime
  ];

  pythonImportsCheck = [ "rapidocr_onnxruntime" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # These are tests for different backends.
  disabledTestPaths = [
    "tests/test_vino.py"
    "tests/test_paddle.py"
  ];

  meta = {
    # This seems to be related to https://github.com/microsoft/onnxruntime/issues/10038
    # Also some related issue: https://github.com/NixOS/nixpkgs/pull/319053#issuecomment-2167713362
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    changelog = "https://github.com/RapidAI/RapidOCR/releases/tag/v${version}";
    description = "Cross platform OCR Library based on OnnxRuntime";
    homepage = "https://github.com/RapidAI/RapidOCR";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "rapidocr_onnxruntime";
  };
}
