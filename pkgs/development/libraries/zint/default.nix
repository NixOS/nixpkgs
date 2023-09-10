{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, qtbase
, qtsvg
, qttools
, testers
, zint
}:

stdenv.mkDerivation rec {
  pname = "zint";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "zint";
    repo = "zint";
    rev = version;
    hash = "sha256-Ay6smir6zUpadmw1WpU+F7e9t7Gk3JNVtf2VVu92bDk=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ qtbase qtsvg qttools ];

  cmakeFlags = [ "-DZINT_QT6:BOOL=ON" ];

  postInstall = ''
    install -Dm644 -t $out/share/applications $src/zint-qt.desktop
    install -Dm644 -t $out/share/pixmaps $src/zint-qt.png
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps $src/frontend_qt/images/scalable/zint-qt.svg
  '';

  passthru.tests.version = testers.testVersion {
    package = zint;
    command = "zint --version";
    inherit version;
  };

  meta = with lib; {
    description = "A barcode generating tool and library";
    longDescription = ''
      The Zint project aims to provide a complete cross-platform open source
      barcode generating solution. The package currently consists of a Qt based
      GUI, a CLI command line executable and a library with an API to allow
      developers access to the capabilities of Zint.
    '';
    homepage = "https://www.zint.org.uk";
    changelog = "https://github.com/zint/zint/blob/${version}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
