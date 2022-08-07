{ lib
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
, dbus-python

, file
, acpi
, coreutils
, alsa-utils
, i3
, procps
, lm_sensors
, libnotify
, xorg
}:

buildPythonPackage rec {
  pname = "py3status";
  version = "3.45";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ksZM2PaeYhluq4nyw6MTFjSb/fQNJha7BRc8/U/7zwg=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    pytz requests tzlocal i3ipc pydbus pygobject3 pyserial setuptools dbus-python file
  ];
  prePatch = ''
    sed -i -e "s|'file|'${file}/bin/file|" py3status/parse_config.py
    sed -i -e "s|\[\"acpi\"|\[\"${acpi}/bin/acpi\"|" py3status/modules/battery_level.py
    sed -i -e "s|notify-send|${libnotify}/bin/notify-send|" py3status/modules/battery_level.py
    sed -i -e "s|/usr/bin/whoami|${coreutils}/bin/whoami|" py3status/modules/external_script.py
    sed -i -e "s|'amixer|'${alsa-utils}/bin/amixer|" py3status/modules/volume_status.py
    sed -i -e "s|'i3-nagbar|'${i3}/bin/i3-nagbar|" py3status/modules/pomodoro.py
    sed -i -e "s|'free|'${procps}/bin/free|" py3status/modules/sysdata.py
    sed -i -e "s|'sensors|'${lm_sensors}/bin/sensors|" py3status/modules/sysdata.py
    sed -i -e "s|'setxkbmap|'${xorg.setxkbmap}/bin/setxkbmap|" py3status/modules/keyboard_layout.py
    sed -i -e "s|'xset|'${xorg.xset}/bin/xset|" py3status/modules/keyboard_layout.py
  '';

  meta = with lib; {
    description = "Extensible i3status wrapper";
    license = licenses.bsd3;
    homepage = "https://github.com/ultrabug/py3status";
    maintainers = with maintainers; [ ];
  };
}
