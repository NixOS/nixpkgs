{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-timepp";
  version = "unstable-2020-03-15";

  src = fetchFromGitHub {
    owner = "zagortenay333";
    repo = "timepp__gnome";
    rev = "34ae477a51267cc1e85992a80cf85a1a7b7005c1";
    sha256 = "1v0xbrp0x5dwizscxh7h984pax4n92bj8iyw3qvjk27ynpxq8ag1";
  };

  uuid = "timepp@zagortenay333";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A todo.txt manager, time tracker, timer, stopwatch, pomodoro, and alarms gnome-shell extension.";
    homepage = "https://github.com/zagortenay333/timepp__gnome";
    license = licenses.gpl3;
    maintainers = with maintainers; [ svsdep ];
  };
}
