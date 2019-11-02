{ stdenv, substituteAll, fetchFromGitHub, taskwarrior, gettext, runtimeShell, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-taskwhisperer";
  version = "12";

  src = fetchFromGitHub {
    owner = "cinatic";
    repo = "taskwhisperer";
    rev = "v${version}";
    sha256 = "187p6p498dd258avsfqqsm322g58y75pc2wbhb4jpmm9insqm1bj";
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
    homepage = https://github.com/cinatic/taskwhisperer;
    broken = versionAtLeast gnome3.gnome-shell.version "3.32"; # Doesnt't support 3.34
  };
}
