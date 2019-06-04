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
  version = "3.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "053znyl68sjmlp3r4br5jxhqqswjfbb1rb8k6f9qpzcym37439r0";
  };

  doCheck = false;
  propagatedBuildInputs = [ pytz requests tzlocal i3ipc pydbus pygobject3 pyserial ];
  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/py3status --prefix PATH : "${stdenv.lib.makeBinPath moduleDeps}"
    wrapProgram $out/bin/py3-cmd --prefix PATH : "${stdenv.lib.makeBinPath moduleDeps}"
  '';

  meta = with stdenv.lib; {
    description = "Extensible i3status wrapper";
    license = licenses.bsd3;
    homepage = https://github.com/ultrabug/py3status;
    maintainers = with maintainers; [ garbas ];
  };
}
