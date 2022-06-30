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
  version = "unstable-2022-05-27";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jwestman";
    repo = pname;
    rev = "cebd9ecadc53790cd547392899589dd5de0ac552";
    sha256 = "sha256-mNR0ooJSRBIXy2E4avXYEdO1aSST+j41TsVg8+kitwo=";
  };

  # Requires pythonfuzz, which I've found difficult to package
  doCheck = false;

  nativeBuildInputs = [
    meson
    ninja
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    python3
  ];

  propagatedBuildInputs = [
    # So that the compiler can find GIR and .ui files
    gobject-introspection
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "A markup language for GTK user interface files";
    homepage = "https://gitlab.gnome.org/jwestman/blueprint-compiler";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.ranfdev ];
    platforms = platforms.all;
  };
}
