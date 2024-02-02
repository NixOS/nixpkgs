{ lib
, pkgs
, buildPythonPackage
, pythonOlder
, fuseSupport ? false, fusepy
, tuiSupport ? false, urwid, urwid-readline, pygments
}:

buildPythonPackage rec {
  pname = "qemu";
  version = "0.6.1.0a1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = pkgs.qemu.src;
  prePatch = ''
    cd python
  '';

  propagatedBuildInputs = [ ]
    ++ lib.optionals fuseSupport [ fusepy ]
    ++ lib.optionals tuiSupport [ urwid urwid-readline pygments ];

  # Project requires avocado-framework for testing
  doCheck = false;

  pythonImportsCheck = [ "qemu" ];

  meta = with lib; {
    homepage = "http://www.qemu.org/";
    description = "Python tooling used by the QEMU project to build, configure, and test QEMU";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ devplayer0 davhau ];
  };
}
