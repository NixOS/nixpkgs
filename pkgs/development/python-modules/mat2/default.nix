{ lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitLab
, substituteAll
, bubblewrap
, exiftool
, ffmpeg
, mime-types
, wrapGAppsHook
, gdk-pixbuf
, gobject-introspection
, librsvg
, poppler_gi
, mutagen
, pygobject3
, pycairo
, dolphinIntegration ? false, plasma5Packages
}:

buildPythonPackage rec {
  pname = "mat2";
  version = "0.12.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    domain = "0xacab.org";
    owner = "jvoisin";
    repo = "mat2";
    rev = version;
    sha256 = "0amxwwmcf47dakfm6zvsksv6ja7rz7dpmd1z2rsspy8yds6zgxs7";
  };

  patches = [
    # hardcode paths to some binaries
    (substituteAll ({
      src = ./paths.patch;
      bwrap = "${bubblewrap}/bin/bwrap";
      exiftool = "${exiftool}/bin/exiftool";
      ffmpeg = "${ffmpeg}/bin/ffmpeg";
      # remove once faf0f8a8a4134edbeec0a73de7f938453444186d is in master
      mimetypes = "${mime-types}/etc/mime.types";
    } // lib.optionalAttrs dolphinIntegration {
      kdialog = "${plasma5Packages.kdialog}/bin/kdialog";
    }))
    # the executable shouldn't be called .mat2-wrapped
    ./executable-name.patch
    # hardcode path to mat2 executable
    ./tests.patch
  ];

  postPatch = ''
    substituteInPlace dolphin/mat2.desktop \
      --replace "@mat2@" "$out/bin/mat2" \
      --replace "@mat2svg@" "$out/share/icons/hicolor/scalable/apps/mat2.svg"
  '';

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    gobject-introspection
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

  checkPhase = ''
    ${python.interpreter} -m unittest discover -v
  '';

  meta = with lib; {
    description = "A handy tool to trash your metadata";
    homepage = "https://0xacab.org/jvoisin/mat2";
    changelog = "https://0xacab.org/jvoisin/mat2/-/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
