{ lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitLab
, fetchpatch
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
  version = "0.12.1";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    domain = "0xacab.org";
    owner = "jvoisin";
    repo = "mat2";
    rev = version;
    sha256 = "sha256-TxHelOr7ygp4R+dW+oJ034l2w9zrB4gn0QLs5Pa4EFE=";
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
    # remove for next release
    (fetchpatch {
      name = "fix-tests-ffmpeg-4.4.patch";
      url = "https://0xacab.org/jvoisin/mat2/-/commit/c9be50f968212b01f8d8ad85e59e19c3e67d8578.patch";
      sha256 = "0895dkv6575ps3drdfnli15cggx27n9irjx0axigrm4ql4ma0648";
    })
    # fix white space error in the tests for exiftool, remove for next release
    (fetchpatch {
      name = "fix-tests-exiftool.patch";
      url = "https://0xacab.org/jvoisin/mat2/-/commit/6df615281b2a649b85ff7670f6d87d3beed0b977.patch";
      sha256 = "1gix63n0mzavnqjq5ll0v210z4vdz4f93aq03bfzlgifxcd9vl1x";
    })
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
    install -Dm 444 nautilus/mat2.py -t "$out/share/nautilus-python/extensions"
    buildPythonPath "$out $pythonPath"
    patchPythonScript "$out/share/nautilus-python/extensions/mat2.py"
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
