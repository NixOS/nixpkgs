{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "iteration-utilities";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MSeifert04";
    repo = "iteration_utilities";
    tag = "v${version}";
    hash = "sha256-SiqNUyuvsD5m5qz5ByYyVln3SSa4/D4EHpmM+pf8ngM=";
  };

  patches = [
    (fetchpatch {
      name = "python314-compat.patch";
      url = "https://github.com/MSeifert04/iteration_utilities/pull/347.patch";
      hash = "sha256-1BzUTbzxIw4kExdrAlS4Pbh1zPweyU78ln2qGL7XL58=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iteration_utilities" ];

  meta = {
    description = "Utilities based on Pythons iterators and generators";
    homepage = "https://github.com/MSeifert04/iteration_utilities";
    changelog = "https://github.com/MSeifert04/iteration_utilities/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
