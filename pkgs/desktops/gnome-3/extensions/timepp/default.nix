{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-timepp-${version}";
  version = "unstable-2019-03-30";

  src = fetchFromGitHub {
    owner = "zagortenay333";
    repo = "timepp__gnome";
    rev = "f90fb5573b37ac89fb57bf62e07d6d3bdb6a2c63";
    sha256 = "0p6rsbm6lf61vzly775qkwc2rcjjl38bkqdxnv4sccqmw2wwclnp";
  };

  uuid = "timepp@zagortenay333";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "A todo.txt manager, time tracker, timer, stopwatch, pomodoro, and alarms gnome-shell extension.";
    homepage = https://github.com/zagortenay333/timepp__gnome;
    license = licenses.gpl3;
    maintainers = with maintainers; [ svsdep ];
  };
}
