{
  lib,
  buildPythonPackage,
  deprecated,
  fetchFromGitea,
  importlib-resources,
  jaconv,
  py-cpuinfo,
  pytest-benchmark,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pykakasi";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "pykakasi";
    rev = "refs/tags/v${version}";
    hash = "sha256-b2lYYdg1RW1xRD3hym7o1EnxzN/U5txVTWRifwZn3k0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    jaconv
    deprecated
  ]
  ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  nativeCheckInputs = [
    py-cpuinfo
    pytest-benchmark
    pytestCheckHook
  ];

  disabledTests = [
    # Assertion error
    "test_aozora"
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "pykakasi" ];

  meta = with lib; {
    description = "Python converter for Japanese Kana-kanji sentences into Kana-Roman";
    homepage = "https://codeberg.org/miurahr/pykakasi";
    changelog = "https://codeberg.org/miurahr/pykakasi/src/tag/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "kakasi";
  };
}
