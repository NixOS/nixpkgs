{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, syrupy
, pillow
, rich
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "rich-pixels";
  version = "2.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "rich-pixels";
    rev = version;
    hash = "sha256-zI6jtEdmBAEGxyASo/6fiHdzwzoSwXN7A5x1CmYS5qc=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    syrupy
  ];

  propagatedBuildInputs = [
    pillow
    rich
  ];

  pythonRelaxDeps = [
    "pillow"
  ];

  pythonImportsCheck = [ "rich_pixels" ];

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
