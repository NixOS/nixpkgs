{ mkDerivation, lib, fetchFromGitHub, nix-update-script, cmake, ninja, qtbase, pantheon }:

mkDerivation rec {
  pname = "adwaita-qt";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = pname;
    rev = version;
    sha256 = "19s97wm96g3828dp8m85j3lsn1n6h5h2zqk4652hcqcgq6xb6gv5";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/CMakeLists.txt \
       --replace "DESTINATION \"\''${QT_PLUGINS_DIR}/styles" "DESTINATION \"$qtPluginPrefix/styles"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A style to bend Qt applications to look like they belong into GNOME Shell";
    homepage = "https://github.com/FedoraQt/adwaita-qt";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
