{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlmi-auth";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lenovo";
    repo = "tlmi-auth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/juXQrb3MsQ6FxmrAa7E1f0vIMu1397tZ1pzLfr56M4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    homepage = "https://github.com/lenovo/tlmi-auth";
    maintainers = with maintainers; [ snpschaaf ];
    description = "Utility for creating signature strings needed for thinklmi certificate based authentication";
    mainProgram = "tlmi-auth";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
})
