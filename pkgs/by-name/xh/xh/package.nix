{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  withNativeTls ? true,
  stdenv,
  darwin,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "xh";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    rev = "v${version}";
    hash = "sha256-rHhL2IWir+DpbNFu2KddslmhhiSpkpU633JYFYCoWvY=";
  };

  cargoHash = "sha256-5V27ZV+5jWFoGMFe5EXmLdX2BjPuWDMdn4DK54ZIfUY=";

  buildFeatures = lib.optional withNativeTls "native-tls";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = lib.optionals withNativeTls (
    if stdenv.hostPlatform.isDarwin then
      [ darwin.apple_sdk.frameworks.SystemConfiguration ]
    else
      [ openssl ]
  );

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  postInstall = ''
    installShellCompletion \
      completions/xh.{bash,fish} \
      --zsh completions/_xh

    installManPage doc/xh.1
    ln -s $out/share/man/man1/xh.1 $out/share/man/man1/xhs.1

    install -m444 -Dt $out/share/doc/xh README.md CHANGELOG.md

    ln -s $out/bin/xh $out/bin/xhs
  '';

  # Nix build happens in sandbox without internet connectivity
  # disable tests as some of them require internet due to nature of application
  doCheck = false;
  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/xh --help > /dev/null
    $out/bin/xhs --help > /dev/null
  '';

  meta = with lib; {
    description = "Friendly and fast tool for sending HTTP requests";
    homepage = "https://github.com/ducaale/xh";
    changelog = "https://github.com/ducaale/xh/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      aaronjheng
    ];
    mainProgram = "xh";
  };
}
