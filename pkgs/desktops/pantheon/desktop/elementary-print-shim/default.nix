{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "elementary-print-shim";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "print";
    rev = version;
    sha256 = "sha256-l2IUu9Mj22lZ5yajPcsGrJcJDakNu4srCV0Qea5ybPA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [ gtk3 ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Simple shim for printing support via Contractor";
    homepage = "https://github.com/elementary/print";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.print";
  };
}
