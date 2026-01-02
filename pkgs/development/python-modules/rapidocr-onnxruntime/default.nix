{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  fetchzip,
  replaceVars,

  setuptools,
  pyclipper,
  opencv-python,
  numpy,
  six,
  shapely,
  pyyaml,
  pillow,
  onnxruntime,
  tqdm,

  pytestCheckHook,
  requests,
}:
let
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "RapidAI";
    repo = "RapidOCR";
    tag = "v${version}";
    hash = "sha256-x0VELDKOffxbV3v0aDFJFuDC4YfsGM548XWgINmRc3M=";
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
    (replaceVars ./setup-py-override-version-checking.patch {
      inherit version;
    })
  ];

  postPatch = ''
    mv setup_onnxruntime.py setup.py

    ln -s ${models}/* rapidocr_onnxruntime/models

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
    tqdm
  ];

  pythonImportsCheck = [ "rapidocr_onnxruntime" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  # These are tests for different backends.
  disabledTestPaths = [
    "tests/test_vino.py"
    "tests/test_paddle.py"
  ];

  disabledTests = [
    # Needs Internet access
    "test_long_img"
  ];

  # rapidocr-onnxruntime has been renamed to rapidocr by upstream since 2.0.0. However, some packages like open-webui still requires rapidocr-onnxruntime 1.4.4. Therefore we set no auto update here.
  # nixpkgs-update: no auto update
  passthru.skipBulkUpdate = true;

  meta = {
    changelog = "https://github.com/RapidAI/RapidOCR/releases/tag/${src.tag}";
    description = "Cross platform OCR Library based on OnnxRuntime";
    homepage = "https://github.com/RapidAI/RapidOCR";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wrvsrx ];
    mainProgram = "rapidocr_onnxruntime";
  };
}
