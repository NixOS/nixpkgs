{ stdenv, substituteAll, fetchFromGitHub, taskwarrior }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-taskwhisperer-${version}";
  version = "11";

  src = fetchFromGitHub {
    owner = "cinatic";
    repo = "taskwhisperer";
    rev = "v${version}";
    sha256 = "1g1301rwnfg5jci78bjpmgxrn78ra80m1zp2inhfsm8jssr1i426";
  };

  buildInputs = [ taskwarrior ];

  uuid = "taskwhisperer-extension@infinicode.de";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp *.js $out/share/gnome-shell/extensions/${uuid}
    cp -r extra $out/share/gnome-shell/extensions/${uuid}
    cp -r icons $out/share/gnome-shell/extensions/${uuid}
    cp -r locale $out/share/gnome-shell/extensions/${uuid}
    cp -r schemas $out/share/gnome-shell/extensions/${uuid}
    cp metadata.json $out/share/gnome-shell/extensions/${uuid}
    cp settings.ui $out/share/gnome-shell/extensions/${uuid}
    cp stylesheet.css $out/share/gnome-shell/extensions/${uuid}
  '';

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      task = "${taskwarrior}/bin/task";
    })
  ];

  meta = with stdenv.lib; {
    description = "GNOME Shell TaskWarrior GUI";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonafato ];
    homepage = https://github.com/cinatic/taskwhisperer;
  };
}
