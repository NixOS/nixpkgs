{ lib
, stdenv
, buildPythonPackage
, unittestCheckHook
, pythonOlder
, fetchFromGitLab
, fetchpatch
, substituteAll
, bubblewrap
, exiftool
, ffmpeg
, mailcap
, wrapGAppsHook
, gdk-pixbuf
, gobject-introspection
, librsvg
, poppler_gi
, mutagen
, pygobject3
, pycairo
, dolphinIntegration ? false
, plasma5Packages
}:

buildPythonPackage rec {
  pname = "mat2";
  version = "0.13.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    domain = "0xacab.org";
    owner = "jvoisin";
    repo = "mat2";
    rev = version;
    hash = "sha256-H3l8w2F+ZcJ1P/Dg0ZVBJPUK0itLocL7a0jeSrG3Ws8=";
  };

  patches = [
    # hardcode paths to some binaries
    (substituteAll ({
      src = ./paths.patch;
      exiftool = "${exiftool}/bin/exiftool";
      ffmpeg = "${ffmpeg}/bin/ffmpeg";
    } // lib.optionalAttrs dolphinIntegration {
      kdialog = "${plasma5Packages.kdialog}/bin/kdialog";
    }))
    # the executable shouldn't be called .mat2-wrapped
    ./executable-name.patch
    # hardcode path to mat2 executable
    ./tests.patch
    # fix gobject-introspection typelib path for Nautilus extension
    (substituteAll {
      src = ./fix_poppler.patch;
      poppler_path = "${poppler_gi}/lib/girepository-1.0";
    })
    # https://0xacab.org/jvoisin/mat2/-/issues/178
    (fetchpatch {
      url = "https://0xacab.org/jvoisin/mat2/-/commit/618e0a8e3984fd534b95ef3dbdcb8a76502c90b5.patch";
      hash = "sha256-l9UFim3hGj+d2uKITiDG1OnqGeo2McBIiRSmK0Vidg8=";
    })
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    (substituteAll {
      src = ./bubblewrap-path.patch;
      bwrap = "${bubblewrap}/bin/bwrap";
    })
  ];

  postPatch = ''
    substituteInPlace dolphin/mat2.desktop \
      --replace "@mat2@" "$out/bin/mat2" \
      --replace "@mat2svg@" "$out/share/icons/hicolor/scalable/apps/mat2.svg"
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
    poppler_gi
  ];

  propagatedBuildInputs = [
    mutagen
    pygobject3
    pycairo
  ];

  postInstall = ''
    install -Dm 444 data/mat2.svg -t "$out/share/icons/hicolor/scalable/apps"
    install -Dm 444 doc/mat2.1 -t "$out/share/man/man1"
    install -Dm 444 nautilus/mat2.py -t "$out/share/nautilus-python/extensions"
    buildPythonPath "$out $pythonPath $propagatedBuildInputs"
    patchPythonScript "$out/share/nautilus-python/extensions/mat2.py"
  '' + lib.optionalString dolphinIntegration ''
    install -Dm 444 dolphin/mat2.desktop -t "$out/share/kservices5/ServiceMenus"
  '';

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-v" ];

  meta = with lib; {
    description = "A handy tool to trash your metadata";
    homepage = "https://0xacab.org/jvoisin/mat2";
    changelog = "https://0xacab.org/jvoisin/mat2/-/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
