{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  stdlib-list,
  pytestCheckHook,
  pyyaml,
  setuptools,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydeps";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thebjorn";
    repo = "pydeps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZHD8ux3GLm5OsTkaEZfix5zgsdbLHpIxVtwKByduEzk=";
  };

  build-system = [ setuptools ];

  buildInputs = [ graphviz ];

  dependencies = [
    graphviz
    stdlib-list
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    toml
  ];

  postPatch = ''
    # Path is hard-coded
    substituteInPlace pydeps/dot.py \
      --replace "dot -Gstart=1" "${lib.makeBinPath [ graphviz ]}/dot -Gstart=1"
  '';

  disabledTests = [
    # Would require to have additional modules available
    "test_find_package_names"
  ];

  pythonImportsCheck = [ "pydeps" ];

  meta = {
    description = "Python module dependency visualization";
    homepage = "https://github.com/thebjorn/pydeps";
    changelog = "https://github.com/thebjorn/pydeps/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pydeps";
  };
})
