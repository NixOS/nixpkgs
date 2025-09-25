{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # Build system
  hatchling,
  hatch-fancy-pypi-readme,

  # Dependencies
  ffmpeg,
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

  # Optional dependencies
  ipython,
  manim,
  manimgl,
  setuptools,
  pyqt6,
  pyside6,
  docutils,
}:
buildPythonPackage rec {
  pname = "manim-slides";
  version = "5.5.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = "manim-slides";
    tag = "v${version}";
    hash = "sha256-eCtV3xo6PxB6Nha4XuQmmlkAscmeN0O9tgUZ5L4ZroU=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  pythonRelaxDeps = [
    "rtoml" # We only package version 0.10, but manim-slides depends on 0.11.
  ];
  pythonRemoveDeps = [
    "av" # It can use ffmpeg, which we already provide.
  ];

  dependencies = [
    ffmpeg
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
  ];

  optional-dependencies = lib.fix (self: {
    full = self.magic ++ self.manim ++ self.sphinx-directive;
    magic = self.manim ++ [
      ipython
    ];
    manim = [
      manim
    ];
    manimgl = [
      manimgl
      setuptools
    ];
    pyqt6 = [
      pyqt6
    ];
    pyqt6-full = self.full ++ self.pyqt6;
    pyside6 = [
      pyside6
    ];
    pyside6-full = self.full ++ self.pyside6;
    sphinx-directive = self.manim ++ [
      docutils
    ];
  });

  pythonImportsCheck = [
    "manim_slides"
  ];

  meta = {
    changelog = "https://github.com/jeertmans/manim-slides/blob/${src.tag}/CHANGELOG.md";
    description = "Tool for live presentations using manim";
    homepage = "https://github.com/jeertmans/manim-slides";
    license = lib.licenses.mit;
    mainProgram = "manim-slides";
    maintainers = [ lib.maintainers.bpeetz ];
  };
}
