{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  stdenv,
  pkg-config,
  openssl,
  nmap,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unimap";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = "unimap";
    rev = finalAttrs.version;
    hash = "sha256-bRPOxK4wU8giK+fF7cFWEoWl2z7le5nOm4H6XvSYANA=";
  };

  cargoHash = "sha256-CFyFjASiuCPwWlv3fC0P9P5yIsb2tQt7hKbBYKyDOnQ=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ]
  ++ lib.optionals (stdenv.hostPlatform.isAarch && stdenv.hostPlatform.isLinux) [
    pkg-config
  ];

  # only depends on openssl on aarch/arm linux
  buildInputs = lib.optionals (stdenv.hostPlatform.isAarch && stdenv.hostPlatform.isLinux) [
    openssl
  ];

  nativeCheckInputs = [ nmap ];

  env = lib.optionalAttrs (stdenv.hostPlatform.isAarch && stdenv.hostPlatform.isLinux) {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    installManPage unimap.1
    wrapProgram $out/bin/unimap \
      --prefix PATH : ${lib.makeBinPath [ nmap ]}
  '';

  meta = {
    description = "Scan only once by IP address and reduce scan times with Nmap for large amounts of data";
    homepage = "https://github.com/Edu4rdSHL/unimap";
    changelog = "https://github.com/Edu4rdSHL/unimap/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      sheeeng
    ];
    mainProgram = "unimap";
  };
})
