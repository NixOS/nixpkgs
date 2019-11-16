{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, pytz
, tzlocal
, i3ipc
, pydbus
, pygobject3
, pyserial
, makeWrapper
, setuptools
, dbus-python
, file
, acpi
, coreutils
, alsaUtils
, lm_sensors
, xorg
}:
let
  moduleDeps = [ file acpi alsaUtils coreutils lm_sensors xorg.setxkbmap xorg.xset ];
in
buildPythonPackage rec {
  pname = "py3status";
  version = "3.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c208c680d1511e8c1dc950a930d3ee1b83f2dbfaac1308cd43c4773810fee89b";
  };

  doCheck = false;
  propagatedBuildInputs = [
    pytz requests tzlocal i3ipc pydbus pygobject3 pyserial setuptools dbus-python
  ];
  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/py3status --prefix PATH : "${stdenv.lib.makeBinPath moduleDeps}"
    wrapProgram $out/bin/py3-cmd --prefix PATH : "${stdenv.lib.makeBinPath moduleDeps}"
  '';

  meta = with stdenv.lib; {
    description = "Extensible i3status wrapper";
    license = licenses.bsd3;
    homepage = https://github.com/ultrabug/py3status;
    maintainers = with maintainers; [ ];
  };
}
