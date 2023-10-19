{ lib
, buildPythonPackage
, acpi
, alsa-utils
, coreutils
, dbus-python
, fetchPypi
, file
, i3
, i3ipc
, libnotify
, lm_sensors
, procps
, pydbus
, pygobject3
, pyserial
, pytz
, requests
, setuptools
, tzlocal
, xorg
}:

buildPythonPackage rec {
  pname = "py3status";
  version = "3.51";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x4MftAC1TyR4FEvl+ytwCYg2cm5qAG/X/MJUhJRGlkU=";
  };

  propagatedBuildInputs = [
    pytz
    requests
    tzlocal
    i3ipc
    pydbus
    pygobject3
    pyserial
    setuptools
    dbus-python
    file
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

  doCheck = false;

  meta = with lib; {
    description = "Extensible i3status wrapper";
    homepage = "https://github.com/ultrabug/py3status";
    changelog = "https://github.com/ultrabug/py3status/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
