{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, rich
, syrupy
}:

buildPythonPackage rec {
  pname = "rich-pixels";
  version = "2.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "rich-pixels";
    rev = "refs/tags/${version}";
    hash = "sha256-zI6jtEdmBAEGxyASo/6fiHdzwzoSwXN7A5x1CmYS5qc=";
  };

  pythonRelaxDeps = [
    "pillow"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    pillow
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "rich_pixels"
  ];

  meta = with lib; {
    description = "A Rich-compatible library for writing pixel images and ASCII art to the terminal";
    homepage = "https://github.com/darrenburns/rich-pixels";
    changelog = "https://github.com/darrenburns/rich-pixels/releases/tag/${src.rev}";
    # upstream has no license specified
    # https://github.com/darrenburns/rich-pixels/issues/11
    license = licenses.unfree;
    maintainers = with maintainers; [ figsoda ];
  };
}
