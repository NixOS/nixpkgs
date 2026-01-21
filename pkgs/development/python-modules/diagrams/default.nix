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
  round,
}:

buildPythonPackage rec {
  pname = "diagrams";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = "diagrams";
    tag = "v${version}";
    hash = "sha256-uDBmQSEn9LMT2CbR3VDhxW1ec4udXN5wZ1H1+RX/K0U=";
  };

  patches = [
    # Add build-system, https://github.com/mingrammer/diagrams/pull/1089
    ./0001-Add-build-system-section.patch
    # Fix poetry include, https://github.com/mingrammer/diagrams/pull/1128
    ./0002-Fix-packaging-Ensure-resources-are-included.patch
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

  meta = {
    description = "Diagram as Code";
    homepage = "https://diagrams.mingrammer.com/";
    changelog = "https://github.com/mingrammer/diagrams/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ addict3d ];
  };
}
