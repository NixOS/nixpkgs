{ python3
, stdenv
, fetchFromGitLab
, gobject-introspection
, lib
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "blueprint-compiler";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jwestman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LXZ6n1oCbPa0taVbUZf52mGECrzXIcF8EaMVJ30rMtc=";
  };

  # Requires pythonfuzz, which I've found difficult to package
  doCheck = false;

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    python3
  ];

  propagatedBuildInputs = [
    # So that the compiler can find GIR and .ui files
    gobject-introspection
  ];

  meta = with lib; {
    description = "A markup language for GTK user interface files";
    homepage = "https://gitlab.gnome.org/jwestman/blueprint-compiler";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.ranfdev ];
    platforms = platforms.all;
  };
}
