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
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "zint";
    repo = "zint";
    rev = version;
    sha256 = "sha256-ozhXy7ftmGz1XvmF8AS1ifWJ3Q5hLSsysB8qLUP60n8=";
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
  };
}
