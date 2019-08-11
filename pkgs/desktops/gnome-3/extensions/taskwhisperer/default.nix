{ stdenv, substituteAll, fetchFromGitHub, taskwarrior, gettext, runtimeShell }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-taskwhisperer-${version}";
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
    "INSTALLBASE=${placeholder ''out''}/share/gnome-shell/extensions"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      task = "${taskwarrior}/bin/task";
      shell = "${runtimeShell}";
    })
  ];

  meta = with stdenv.lib; {
    description = "GNOME Shell TaskWarrior GUI";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonafato ];
    homepage = https://github.com/cinatic/taskwhisperer;
  };
}
