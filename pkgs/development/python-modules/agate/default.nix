{
  lib,
  stdenv,
  babel,
  buildPythonPackage,
  cssselect,
  fetchFromGitHub,
  glibcLocales,
  isodate,
  leather,
  lxml,
  parsedatetime,
  pyicu,
  pytestCheckHook,
  python-slugify,
  pytimeparse,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "agate";
  version = "1.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate";
    tag = finalAttrs.version;
    hash = "sha256-REo26vSWFzWsvJzmqlc5A5xEYA2TebQFW6jFRIbH53I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    babel
    isodate
    leather
    parsedatetime
    python-slugify
    pytimeparse
  ];

  nativeCheckInputs = [
    cssselect
    glibcLocales
    lxml
    pyicu
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Output is slightly different on macOS
    "test_cast_format_locale"
  ];

  pythonImportsCheck = [ "agate" ];

  meta = {
    description = "Python data analysis library that is optimized for humans instead of machines";
    homepage = "https://github.com/wireservice/agate";
    changelog = "https://github.com/wireservice/agate/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
