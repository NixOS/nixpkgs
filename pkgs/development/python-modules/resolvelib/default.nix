{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  commentjson,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "resolvelib";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    tag = version;
    hash = "sha256-AxxW6z51fZGqs5UwY3NEBQL8894uQDuRyVrKzol3ny0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-with-packaging-26.patch";
      url = "https://github.com/sarugaku/resolvelib/commit/017d3a7a9ecdd01f5349d263e31d196f4f27e483.patch";
      hash = "sha256-sEH5R/U8APC1Lti47ZXHLruVwUbwfGp2HAp7nj+l1KM=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    commentjson
    pytestCheckHook
  ];

  pythonImportsCheck = [ "resolvelib" ];

  meta = {
    description = "Resolve abstract dependencies into concrete ones";
    homepage = "https://github.com/sarugaku/resolvelib";
    changelog = "https://github.com/sarugaku/resolvelib/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
