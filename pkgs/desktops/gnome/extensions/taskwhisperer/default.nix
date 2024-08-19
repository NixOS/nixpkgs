{ lib, stdenv, substituteAll, fetchFromGitHub, taskwarrior2, gettext, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-taskwhisperer";
  version = "20";

  src = fetchFromGitHub {
    owner = "cinatic";
    repo = "taskwhisperer";
    rev = "v${version}";
    sha256 = "sha256-UVBLFXsbOPRXC4P5laZ82Rs08yXnNnzJ+pp5fbx6Zqc=";
  };

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    taskwarrior2
  ];

  passthru = {
    extensionUuid = "taskwhisperer-extension@infinicode.de";
    extensionPortalSlug = "taskwhisperer";
  };

  makeFlags = [
    "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      task = "${taskwarrior2}/bin/task";
      shell = runtimeShell;
    })
  ];

  meta = with lib; {
    description = "GNOME Shell TaskWarrior GUI";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonafato ];
    homepage = "https://github.com/cinatic/taskwhisperer";
  };
}
