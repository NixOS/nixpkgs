{ stdenv
, lib
, fetchFromGitHub
, go
, pkg-config
, libgudev
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "go-gir-generator";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-lFseui/M3+TyfYoa+rnS0cGhN6gdLrgpzgOwqzYcyPk=";
  };

  nativeBuildInputs = [
    pkg-config
    go
    gobject-introspection
  ];

  buildInputs = [
    libgudev
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "GOCACHE=$(TMPDIR)/go-cache"
  ];

  meta = with lib; {
    description = "Generate static golang bindings for GObject";
    homepage = "https://github.com/linuxdeepin/go-gir-generator";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
