{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  beautifulsoup4,
  bitmath,
  bpylist2,
  click,
  mako,
  markdown2,
  more-itertools,
  objexplore,
  packaging,
  pathvalidate,
  pip,
  ptpython,
  psutil,
  pytimeparse2,
  pyyaml,
  requests,
  rich-theme-manager,
  rich,
  shortuuid,
  strpdatetime,
  tenacity,
  textx,
  toml,
  tzdata,
  utitools,
  whenever,
  wrapt,
  wurlitzer,
  xdg-base-dirs,
  # tests
  pytestCheckHook,
  pytest-mock,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "osxphotos";
  version = "0.75.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhetTbull";
    repo = "osxphotos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9oQ9yLNHACLgOegNRcuysGIo8cbYLhlkNa41Y+YHFTM=";
  };

  pythonRelaxDeps = [
    "bitmath"
    "mako"
    "more-itertools"
    "objexplore"
    "rich"
    "textx"
    "tenacity"
    "whenever"
  ];

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    bitmath
    bpylist2
    click
    mako
    markdown2
    more-itertools
    objexplore
    packaging
    pathvalidate
    pip
    psutil
    ptpython
    pytimeparse2
    pyyaml
    requests
    rich
    rich-theme-manager
    shortuuid
    strpdatetime
    tenacity
    textx
    toml
    tzdata
    utitools
    whenever
    wrapt
    wurlitzer
    xdg-base-dirs
  ];

  pythonImportsCheck = [ "osxphotos" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    "test_datetime_naive_to_local"
    "test_from_to_date_tz"
    "test_function_url"
    "test_get_local_tz"
    "test_query_from_to_date_alt_location"
    "test_query_function_url"
  ];

  meta = {
    description = "Export photos from Apple's macOS Photos app and query the Photos library database to access metadata about images";
    homepage = "https://github.com/RhetTbull/osxphotos";
    changelog = "https://github.com/RhetTbull/osxphotos/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    # missing utitools dependency
    broken = true && stdenv.hostPlatform.isDarwin;
  };
})
