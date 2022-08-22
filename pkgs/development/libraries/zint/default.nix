{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, qtbase
, qttools
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "zint";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "woo-j";
    repo = "zint";
    rev = version;
    sha256 = "sha256-ozhXy7ftmGz1XvmF8AS1ifWJ3Q5hLSsysB8qLUP60n8=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ qtbase qttools ];

  postInstall = ''
    install -Dm644 $src/zint-qt.desktop $out/share/applications/zint-qt.desktop
    install -Dm644 $src/zint-qt.png $out/share/pixmaps/zint-qt.png
    install -Dm644 $src/frontend_qt/images/scalable/zint-qt.svg $out/share/icons/hicolor/scalable/apps/zint-qt.svg
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "A barcode generating tool and library";
    longDescription = ''
      The Zint project aims to provide a complete cross-platform open source
      barcode generating solution. The package currently consists of a Qt based
      GUI, a CLI command line executable and a library with an API to allow
      developers access to the capabilities of Zint.
    '';
    homepage = "http://www.zint.org.uk";
    changelog = "https://github.com/woo-j/zint/blob/${version}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
  };
}
