{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, openssl
}:
let
  name = "tlmi-auth";
  version = "1.0.1";
in
stdenv.mkDerivation {
  pname = name;
  version = version;

  src = fetchFromGitHub {
    owner = "lenovo";
    repo = name;
    rev = "v${version}";
    hash = "sha256-/juXQrb3MsQ6FxmrAa7E1f0vIMu1397tZ1pzLfr56M4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    openssl
  ];

  meta = with lib; {
    homepage = "https://github.com/lenovo/tlmi-auth";
    maintainers = with maintainers; [ snpschaaf ];
    description = "Utility for creating signature strings needed for thinklmi certificate based authentication";
    mainProgram = name;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
