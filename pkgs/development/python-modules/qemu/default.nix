{
  lib,
  buildPythonPackage,
  pythonOlder,
  qemu,
  setuptools,
  fuseSupport ? false,
  fusepy,
  tuiSupport ? false,
  urwid,
  urwid-readline,
  pygments,
}:

buildPythonPackage {
  pname = "qemu";
  version = "0.6.1.0a1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = qemu.src;

  prePatch = ''
    cd python
  '';

  # ensure the version matches qemu-xxx/python/VERSION
  preConfigure = ''
    if [ "$version" != "$(cat ./VERSION)" ]; then
      echo "The nix package version attribute is not in sync with the QEMU source version" > /dev/stderr
      echo "Please update the version attribute in the nix expression of python3Packages.qemu to '$version'" > /dev/stderr
      exit 1
    fi
  '';

  buildInputs = [ setuptools ];

  propagatedBuildInputs =
    [ ]
    ++ lib.optionals fuseSupport [ fusepy ]
    ++ lib.optionals tuiSupport [
      urwid
      urwid-readline
      pygments
    ];

  # Project requires avocado-framework for testing, therefore replacing check phase
  checkPhase = ''
    for bin in $out/bin/*; do
      $bin --help
    done
  '';

  pythonImportsCheck = [ "qemu" ];

  preFixup =
    (lib.optionalString (!tuiSupport) ''
      rm $out/bin/qmp-tui
    '')
    + (lib.optionalString (!fuseSupport) ''
      rm $out/bin/qom-fuse
    '');

  meta = with lib; {
    homepage = "http://www.qemu.org/";
    description = "Python tooling used by the QEMU project to build, configure, and test QEMU";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      devplayer0
      davhau
    ];
  };
}
