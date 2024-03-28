{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

, manim
, ffmpeg

, av
, click
, click-default-group
, jinja2
, lxml
, numpy
, opencv4
, pillow
, pydantic
, pydantic-extra-types
, python-pptx
, qtpy
, requests
, rich
, rtoml
, tqdm
, pyqt6

  # Optional dependencies
, ipython

  # Hooks
, pdm-backend
, pythonRelaxDepsHook

  # As Module or application?
, withGui ? false
}:
buildPythonPackage rec {
  pname = "manim-slides";
  format = "pyproject";
  version = "5.1.3";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = "manim-slides";
    rev = "refs/tags/v${version}";
    hash = "sha256-WZR95swapT2Fbu6mbuHLjMu3Okq/wKFabzN7xpZw0/g=";
  };

  nativeBuildInputs = [ pdm-backend pythonRelaxDepsHook ];

  pythonRemoveDeps = [ "opencv-python" ];

  pythonRelaxDeps = [ "rtoml" "qtpy" ];

  propagatedBuildInputs = [
    av
    click
    click-default-group
    jinja2
    lxml
    numpy
    opencv4
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
  ++ lib.lists.optional (!withGui)
    ipython
  ++ lib.lists.optional withGui
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
