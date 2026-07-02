{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  tuiSupport ? false,
  urwid,
  urwid-readline,
  pygments,
}:

buildPythonPackage rec {
  pname = "qemu-qmp";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "qemu-project";
    repo = "python-qemu-qmp";
    tag = "v${version}";
    hash = "sha256-iuYiYjUfAxXzG7w7s8I2l5oXROyTjswn++vYs9lauGA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs =
    [ ]
    ++ lib.optionals tuiSupport [
      pygments
      urwid
      urwid-readline
    ];

  # Make sure all binaries have their necessary inputs
  checkPhase = ''
    for bin in $out/bin/*; do
      $bin --help
    done
  '';
  pythonImportsCheck = [ "qemu.qmp" ];

  preFixup = lib.optionalString (!tuiSupport) ''
    rm $out/bin/qmp-tui
  '';

  meta = {
    description = "Asyncio library for communicating with QEMU Monitor Protocol (“QMP”) servers";
    # no changelog, included in the README of the homepage
    homepage = "https://gitlab.com/qemu-project/python-qemu-qmp";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Only
    ];

    maintainers = with lib.maintainers; [ brianmcgillion ];
  };
}
