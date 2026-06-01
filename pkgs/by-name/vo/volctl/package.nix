{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  libpulseaudio,
  glib,
  gtk3,
  pango,
  libxfixes,
}:

python3Packages.buildPythonApplication rec {
  pname = "volctl";
  version = "0.9.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "buzz";
    repo = "volctl";
    rev = "v${version}";
    sha256 = "sha256-zL1m/DeSOrNkjt9B+8pdy2jUgjSp7tt81UpAueGsIwQ=";
  };

  postPatch = ''
    substituteInPlace volctl/xwrappers.py \
      --replace 'libXfixes.so' "${libxfixes}/lib/libXfixes.so" \
      --replace 'libXfixes.so.3' "${libxfixes}/lib/libXfixes.so.3"
  '';

  preBuild = ''
    export LD_LIBRARY_PATH=${libpulseaudio}/lib
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    pango
    gtk3
  ]
  ++ (with python3Packages; [
    pulsectl
    click
    pycairo
    pygobject3
    pyyaml
  ]);

  # with strictDeps importing "gi.repository.Gtk" fails with "gi.RepositoryError: Typelib file for namespace 'Pango', version '1.0' not found"
  strictDeps = false;

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "volctl" ];

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${libpulseaudio}/lib")
  '';

  meta = {
    description = "PulseAudio enabled volume control featuring per-app sliders";
    homepage = "https://buzz.github.io/volctl/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "volctl";
  };
}
