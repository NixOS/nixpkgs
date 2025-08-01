{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbusSupport ? stdenv.hostPlatform.isLinux,
  dbus,
  # rustls will be used for TLS if useOpenSSL=false
  useOpenSSL ? stdenv.hostPlatform.isLinux,
  openssl,
  notificationSupport ? stdenv.hostPlatform.isLinux,
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = "tiny";
    rev = "v${version}";
    hash = "sha256-phjEae2SS3zkSpuhhE4iscUM8ij8DT47YLIMATMG/+Q=";
  };

  cargoHash = "sha256-lyjTl0kbtfQdqSqxti1181+oDVYP4U++v2JEOYvI7aM=";

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux pkg-config;
  buildInputs = lib.optionals dbusSupport [ dbus ] ++ lib.optionals useOpenSSL [ openssl ];

  buildFeatures = lib.optional notificationSupport "desktop-notifications";

  meta = {
    description = "Console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      vyp
    ];
    mainProgram = "tiny";
  };
}
