{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:
buildPythonPackage {
  pname = "examples";
  version = "0-unstable-2021-05-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timothycrosley";
    repo = "examples";
    # no commits for 3 years and I don't know what revision
    # uses version on PyPI so I am packaging last commit
    rev = "2667ad2793c008d4f4c1c62851c99bf7d0d36290";
    hash = "sha256-4u5SiM9QOMLYFG6thX5bu6Hw2n0MFUvJlkaiUw/CyA4=";
  };

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  patches = [
    ./update-poetry.patch
  ];

  meta = {
    homepage = "https://github.com/timothycrosley/examples";
    description = "Tests and Documentation Done by Example";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ perchun ];
  };
}
