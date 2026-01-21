{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  prettytable,
  simplejson,

  # optional-dependencies
  pillow,

  # tests
  numpy,
  pandas,
  pytestCheckHook,
  requests,
}:

let
  optional-dependencies = {
    images = [ pillow ];
  };
in
buildPythonPackage (finalAttrs: {
  pname = "pyecharts";
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyecharts";
    repo = "pyecharts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AMdPsTQsndc0fr4NF2AnJy98k4I2832/GNWeY4IWSRA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    prettytable
    simplejson
  ];

  inherit optional-dependencies;

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
    requests
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pyecharts" ];

  disabledTests = [
    # Tests require network access
    "test_render_embed_js"
    "test_display_javascript_v2"
    "test_lines3d_base"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # pyecharts.exceptions.WordCloudMaskImageException
    "test_wordcloud_encode_image_to_base64_os_error"
  ];

  meta = {
    description = "Python Echarts Plotting Library";
    homepage = "https://github.com/pyecharts/pyecharts";
    changelog = "https://github.com/pyecharts/pyecharts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
