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
, setuptools

, file
, acpi
, coreutils
, alsaUtils
, i3
, procps
, lm_sensors
, libnotify
, xorg
}:

buildPythonPackage rec {
  pname = "py3status";
  version = "3.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14p0ikbgy1pgphy00gvi6zpkz2kf5mwmawbdqs0l57s0fzrz7xwz";
  };

  doCheck = false;
  propagatedBuildInputs = [
    pytz requests tzlocal i3ipc pydbus pygobject3 pyserial setuptools
  ];
  buildInputs = [ file ];
  prePatch = ''
    sed -i -e "s|'file|'${file}/bin/file|" py3status/parse_config.py
    sed -i -e "s|\[\"acpi\"|\[\"${acpi}/bin/acpi\"|" py3status/modules/battery_level.py
    sed -i -e "s|notify-send|${libnotify}/bin/notify-send|" py3status/modules/battery_level.py
    sed -i -e "s|/usr/bin/whoami|${coreutils}/bin/whoami|" py3status/modules/external_script.py
    sed -i -e "s|'amixer|'${alsaUtils}/bin/amixer|" py3status/modules/volume_status.py
    sed -i -e "s|'i3-nagbar|'${i3}/bin/i3-nagbar|" py3status/modules/pomodoro.py
    sed -i -e "s|'free|'${procps}/bin/free|" py3status/modules/sysdata.py
    sed -i -e "s|'sensors|'${lm_sensors}/bin/sensors|" py3status/modules/sysdata.py
    sed -i -e "s|'setxkbmap|'${xorg.setxkbmap}/bin/setxkbmap|" py3status/modules/keyboard_layout.py
    sed -i -e "s|'xset|'${xorg.xset}/bin/xset|" py3status/modules/keyboard_layout.py
  '';

  meta = with stdenv.lib; {
    description = "Extensible i3status wrapper";
    license = licenses.bsd3;
    homepage = https://github.com/ultrabug/py3status;
    maintainers = with maintainers; [ ];
  };
}
