{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-timepp-${version}";
  version = "2018.03.17";

  src = fetchFromGitHub {
    owner = "zagortenay333";
    repo = "timepp__gnome";
    rev = "440cf85dc68d9e6ba876793f13910ee6239622cf";
    sha256 = "0idsqsii5rvynvj78w2j7xiiz9rrl3384m5mj6bf6rg8vprpfi8v";
  };

  uuid = "timepp@zagortenay333";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = " A todo.txt manager, time tracker, timer, stopwatch, pomodoro, and alarms gnome-shell extension.";
    homepage = https://github.com/zagortenay333/timepp__gnome;
    license = licenses.gpl3;
    maintainers = with maintainers; [ svsdep ];
  };
}
