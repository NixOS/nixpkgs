{ stdenv, substituteAll, fetchFromGitHub, taskwarrior, gettext, runtimeShell, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-taskwhisperer";
  version = "16";

  src = fetchFromGitHub {
    owner = "cinatic";
    repo = "taskwhisperer";
    rev = "v${version}";
    sha256 = "05w2dfpr5vrydb7ij4nd2gb7c31nxix3j48rb798r4jzl1rakyah";
  };

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    taskwarrior
  ];

  uuid = "taskwhisperer-extension@infinicode.de";

  makeFlags = [
    "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      task = "${taskwarrior}/bin/task";
      shell = runtimeShell;
    })
  ];

  meta = with stdenv.lib; {
    description = "GNOME Shell TaskWarrior GUI";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonafato ];
    homepage = "https://github.com/cinatic/taskwhisperer";
  };
}
