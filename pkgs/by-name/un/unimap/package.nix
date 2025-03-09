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

rustPlatform.buildRustPackage rec {
  pname = "unimap";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = "unimap";
    rev = version;
    hash = "sha256-7UbzE5VXycjo7KNpPe2oqwyZDT4Vk8rQZ6HXT1q9Cw4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ShwFHLfDPc3P8J5gV5CFz/2vrQ5xR01C3sYIejyt860=";

  nativeBuildInputs =
    [
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

  env = lib.optionalAttrs (stdenv.hostPlatform.isAarch && stdenv.hostPlatform.isLinux) {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    installManPage unimap.1
    wrapProgram $out/bin/unimap \
      --prefix PATH : ${lib.makeBinPath [ nmap ]}
  '';

  meta = with lib; {
    description = "Scan only once by IP address and reduce scan times with Nmap for large amounts of data";
    homepage = "https://github.com/Edu4rdSHL/unimap";
    changelog = "https://github.com/Edu4rdSHL/unimap/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "unimap";
  };
}
