{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  jaraco-functools,
  jaraco-context,
  jaraco-collections,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaraco-test";
  version = "5.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.test";
    tag = "v${version}";
    hash = "sha256-Ym0r92xCh+DNpFexqPlRVgcDGYNvnaJHEs5/RMaUr+s=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./darwin-no-doctest.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"coherent.licensed",' ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    jaraco-functools
    jaraco-context
    jaraco-collections
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = lib.optionals stdenv.hostPlatform.isDarwin [
    "--import-mode=prepend"
    "-p"
    "no:tmpdir"
  ];

  pythonImportsCheck = [ "jaraco.test" ];

  meta = {
    description = "Testing support by jaraco";
    homepage = "https://github.com/jaraco/jaraco.test";
    changelog = "https://github.com/jaraco/jaraco.test/blob/${src.tag}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
