{ fetchFromGitLab
, gobject-introspection
, gtk4
, lib
, meson
, ninja
, python3
, stdenv
, testers
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jwestman";
    repo = "blueprint-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L6EGterkZ8EB6xSnJDZ3IMuOumpTpEGnU74X3UgC7k0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];

  propagatedBuildInputs = [
    # For setup hook, so that the compiler can find typelib files
    gobject-introspection
  ];

  doCheck = true;

  checkInputs = [
    gtk4
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A markup language for GTK user interface files";
    homepage = "https://gitlab.gnome.org/jwestman/blueprint-compiler";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ benediktbroich ranfdev ];
    platforms = platforms.unix;
  };
})
