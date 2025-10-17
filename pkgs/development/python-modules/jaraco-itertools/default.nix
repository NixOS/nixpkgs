{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  inflect,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaraco-itertools";
  version = "6.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.itertools";
    tag = "v${version}";
    hash = "sha256-LjWkyY9I8BBYpFm8TT3kq4vk63pNQrnZ15haJCQ5xlk=";
  };

  pythonNamespaces = [ "jaraco" ];

  build-system = [ setuptools-scm ];

  postPatch = ''
    # downloads license texts at build time
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

  dependencies = [
    inflect
    more-itertools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jaraco.itertools" ];

  meta = with lib; {
    description = "Tools for working with iterables";
    homepage = "https://github.com/jaraco/jaraco.itertools";
    license = licenses.mit;
  };
}
