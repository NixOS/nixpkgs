{ lib
, stdenv
, buildPythonPackage
, unittestCheckHook
, pythonOlder
, fetchFromGitLab
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
  version = "0.13.2";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    domain = "0xacab.org";
    owner = "jvoisin";
    repo = "mat2";
    rev = version;
    hash = "sha256-gZl2VH7qCmjrM/UrXPief8hCQKkBHdjG8w0MQvkZ7wk=";
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
  '' + lib.optionalString dolphinIntegration ''
    install -Dm 444 dolphin/mat2.desktop -t "$out/share/kservices5/ServiceMenus"
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-v" ];

  meta = with lib; {
    description = "A handy tool to trash your metadata";
    homepage = "https://0xacab.org/jvoisin/mat2";
    changelog = "https://0xacab.org/jvoisin/mat2/-/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
