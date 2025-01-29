{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  hatchling,
  hatch-fancy-pypi-readme,
  manim,
  ffmpeg,

  av,
  beautifulsoup4,
  click,
  click-default-group,
  jinja2,
  lxml,
  numpy,
  pillow,
  pydantic,
  pydantic-extra-types,
  python-pptx,
  qtpy,
  requests,
  rich,
  rtoml,
  tqdm,
  pyqt6,

  # Optional dependencies
  ipython,

  # As Module or application?
  withGui ? false,
}:
buildPythonPackage rec {
  pname = "manim-slides";
  version = "5.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = "manim-slides";
    tag = "v${version}";
    hash = "sha256-9BPBjTepb1CdCEk1j471NhndLG5Ai1P81VUV6msQPus=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  pythonRelaxDeps = [
    "rtoml"
    "qtpy"
  ];

  dependencies =
    [
      av
      beautifulsoup4
      click
      click-default-group
      jinja2
      lxml
      numpy
      pillow
      pydantic
      pydantic-extra-types
      python-pptx
      qtpy
      requests
      rich
      rtoml
      tqdm

      # avconv is a potential alternative
      ffmpeg
      # This could also be manimgl, but that is not (yet) packaged
      manim
    ]
    ++ lib.lists.optional (!withGui) ipython
    ++
      lib.lists.optional withGui
        # dependency of qtpy (could also be pyqt5)
        pyqt6;

  pythonImportsCheck = [ "manim_slides" ];

  meta = {
    changelog = "https://github.com/jeertmans/manim-slides/blob/${src.rev}/CHANGELOG.md";
    description = "Tool for live presentations using manim";
    homepage = "https://github.com/jeertmans/manim-slides";
    license = lib.licenses.mit;
    mainProgram = "manim-slides";
    maintainers = with lib.maintainers; [ soispha ];
  };
}
