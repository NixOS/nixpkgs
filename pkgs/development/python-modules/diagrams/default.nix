{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  graphviz,
  imagemagick,
  inkscape,
  jinja2,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  round,
}:

buildPythonPackage rec {
  pname = "diagrams";
  version = "0.24.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = "diagrams";
    tag = "v${version}";
    hash = "sha256-N4JGrtgLgGUayFR6/xTf3GZEZjtxC/4De3ZCfRZbi6M=";
  };

  patches = [
    # Add build-system, https://github.com/mingrammer/diagrams/pull/1089
    (fetchpatch {
      name = "add-build-system.patch";
      url = "https://github.com/mingrammer/diagrams/commit/59b84698b142f5a0998ee9e395df717a1b77e9b2.patch";
      hash = "sha256-/zV5X4qgHJs+KO9gHyu6LqQ3hB8Zx+BzOFo7K1vQK78=";
    })
    ./remove-black-requirement.patch
  ];

  pythonRemoveDeps = [ "pre-commit" ];

  pythonRelaxDeps = [ "graphviz" ];

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  build-system = [ poetry-core ];

  # Despite living in 'tool.poetry.dependencies',
  # these are only used at build time to process the image resource files
  nativeBuildInputs = [
    inkscape
    imagemagick
    jinja2
    round
  ];

  dependencies = [ graphviz ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "diagrams" ];

  meta = with lib; {
    description = "Diagram as Code";
    homepage = "https://diagrams.mingrammer.com/";
    changelog = "https://github.com/mingrammer/diagrams/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ addict3d ];
  };
}
