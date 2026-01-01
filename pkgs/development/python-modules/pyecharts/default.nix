{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  numpy,
  pandas,
  pillow,
  prettytable,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "pyecharts";
  version = "2.0.9";
  pyproject = true;

<<<<<<< HEAD
=======
  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "pyecharts";
    repo = "pyecharts";
    tag = "v${version}";
    hash = "sha256-AMdPsTQsndc0fr4NF2AnJy98k4I2832/GNWeY4IWSRA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    prettytable
    simplejson
  ];

  optional-dependencies = {
    images = [ pillow ];
  };

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
    requests
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "pyecharts" ];

  disabledTests = [
    # Tests require network access
    "test_render_embed_js"
    "test_display_javascript_v2"
    "test_lines3d_base"
  ];

  meta = {
    description = "Python Echarts Plotting Library";
    homepage = "https://github.com/pyecharts/pyecharts";
<<<<<<< HEAD
    changelog = "https://github.com/pyecharts/pyecharts/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/pyecharts/pyecharts/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
