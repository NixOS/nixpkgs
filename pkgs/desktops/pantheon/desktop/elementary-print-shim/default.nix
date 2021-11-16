{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "elementary-print-shim";
  version = "0.1.3";

  repoName = "print";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-l2IUu9Mj22lZ5yajPcsGrJcJDakNu4srCV0Qea5ybPA=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Simple shim for printing support via Contractor";
    homepage = "https://github.com/elementary/print";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.print";
  };
}
