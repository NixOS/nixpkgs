{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  pillow,
  qrcode,
  resize-image,

  # optional-dependencies
  hypothesis,
  imagehash,
  syrupy,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "odl-renderer";
  version = "0.5.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "odl-renderer";
    tag = "odl-renderer-v${finalAttrs.version}";
    hash = "sha256-3XTP5ymW6kbNnBQV9UysCG2O4gqQ6+4TmrIpTiu7JJ0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    aiohttp
    pillow
    qrcode
    resize-image
  ];

  optional-dependencies = {
    property = [
      hypothesis
    ];
    visual = [
      imagehash
      syrupy
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
    time-machine
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # likely pillow mismatch, they test exact raw image output match
    "tests/visual/test_color_rendering.py::TestGrayColorVisualRegression::test_gray_text_inline_markup"
    "tests/visual/test_layouts.py::TestLayoutVisualRegression::test_dashboard_layout"
    "tests/visual/test_plot_rendering.py::TestPlotVisualRegression::test_plot_right_legend"
    "tests/visual/test_plot_rendering.py::TestPlotVisualRegression::test_plot_with_axes_and_legend"
    "tests/visual/test_text_rendering.py::TestTextVisualRegression::test_basic_text"
    "tests/visual/test_text_rendering.py::TestTextVisualRegression::test_text_colors"
    "tests/visual/test_text_rendering.py::TestTextVisualRegression::test_text_size"
    "tests/visual/test_text_rendering.py::TestTextVisualRegression::test_text_sizes"
    "tests/visual/test_transform_rendering.py::TestTransformVisualRegression::test_rotated_text"
  ];

  pythonImportsCheck = [
    "odl_renderer"
  ];

  __structuredAttrs = true;

  meta = {
    description = "";
    homepage = "https://github.com/OpenDisplay/odl-renderer";
    changelog = "https://github.com/OpenDisplay/odl-renderer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
