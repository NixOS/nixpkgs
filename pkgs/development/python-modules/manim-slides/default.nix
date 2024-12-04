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
  click,
  click-default-group,
  jinja2,
  lxml,
  numpy,
  opencv-python,
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
  version = "5.1.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = "manim-slides";
    rev = "refs/tags/v${version}";
    hash = "sha256-M500u7x0jQqcqCd3RbS0CpI1nuwNs9URFlHPeGkiT7E=";
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
      click
      click-default-group
      jinja2
      lxml
      numpy
      opencv-python
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

  meta = with lib; {
    changelog = "https://github.com/jeertmans/manim-slides/blob/${src.rev}/CHANGELOG.md";
    description = "Tool for live presentations using manim";
    homepage = "https://github.com/jeertmans/manim-slides";
    license = licenses.mit;
    mainProgram = "manim-slides";
    maintainers = with maintainers; [ soispha ];
  };
}
