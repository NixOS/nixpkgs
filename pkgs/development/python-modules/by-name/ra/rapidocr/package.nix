{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  fetchzip,
  replaceVars,

  setuptools,
  colorlog,
  pyclipper,
  opencv-python,
  omegaconf,
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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "RapidAI";
    repo = "RapidOCR";
    tag = "v${version}";
    hash = "sha256-Q8QtjI+5QDv6zQ96aXLyEepHfMh75DR+ZWj/ygVx3o0=";
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
  pname = "rapidocr";
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
    mkdir -p rapidocr/models

    ln -s ${models}/* rapidocr/models

    echo "from .rapidocr.main import RapidOCR, VisRes" > __init__.py
  '';

  # Upstream expects the source files to be under rapidocr/rapidocr
  # instead of rapidocr for the wheel to build correctly.
  preBuild = ''
    mkdir rapidocr_t
    mv rapidocr rapidocr_t
    mv rapidocr_t rapidocr
  '';

  # Revert the above hack
  postBuild = ''
    mv rapidocr rapidocr_t
    mv rapidocr_t/* .
  '';

  build-system = [ setuptools ];

  dependencies = [
    colorlog
    numpy
    omegaconf
    onnxruntime
    opencv-python
    pillow
    pyclipper
    pyyaml
    requests
    shapely
    six
    tqdm
  ];

  pythonImportsCheck = [ "rapidocr" ];

  # As of version 2.1.0, 61 out of 70 tests require internet access.
  # It's just not plausible to manually pick out ones that actually work
  # in a hermetic build environment anymore :(
  doCheck = false;

  meta = {
    # This seems to be related to https://github.com/microsoft/onnxruntime/issues/10038
    # Also some related issue: https://github.com/NixOS/nixpkgs/pull/319053#issuecomment-2167713362
    badPlatforms = [ "aarch64-linux" ];
    changelog = "https://github.com/RapidAI/RapidOCR/releases/tag/${src.tag}";
    description = "Cross platform OCR Library based on OnnxRuntime";
    homepage = "https://github.com/RapidAI/RapidOCR";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "rapidocr";
  };
}
