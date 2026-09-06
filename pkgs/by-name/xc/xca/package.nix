{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  qt6,
  sphinx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xca";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "chris2511";
    repo = "xca";
    rev = "RELEASE.${finalAttrs.version}";
    hash = "sha256-28K6luMuYcDuNKd/aQG9HX9VN5YkKArl/GQn5spQ+Sg=";
  };

  buildInputs = [
    openssl
    qt6.qtbase
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    sphinx
    qt6.wrapQtAppsHook
  ];

  # Needed for qcollectiongenerator (see https://github.com/NixOS/nixpkgs/pull/92710)
  env.QT_PLUGIN_PATH = "${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/xca.app" "$out/Applications/xca.app"
  '';

  meta = {
    description = "X509 certificate generation tool, handling RSA, DSA and EC keys, certificate signing requests (PKCS#10) and CRLs";
    mainProgram = "xca";
    homepage = "https://hohnstaedt.de/xca/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    inherit (qt6.qtbase.meta) platforms;
  };
})
