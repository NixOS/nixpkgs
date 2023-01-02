{ gtk4
, python3
, stdenv
, fetchFromGitLab
, gobject-introspection
, lib
, meson
, ninja
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

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    python3
    gtk4
  ] ++ (with python3.pkgs; [
    pygobject3
    wrapPython
  ]);

  propagatedBuildInputs = [
    gobject-introspection
  ];

  postFixup = ''
    makeWrapperArgs="\
      --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH \
      --prefix PYTHONPATH : \"$(toPythonPath $out):$(toPythonPath ${python3.pkgs.pygobject3})\""
    wrapPythonPrograms
  '';

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
