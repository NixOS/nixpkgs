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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = "unimap";
    rev = version;
    hash = "sha256-QQZNeZUB6aHnYz7B7uqL8I9gkk4JvQJ4TD9NxECd6JA=";
  };

  cargoHash = "sha256-1haSdmhK14XvKunSbj9jPTuHJK5tWdzdFAqxhg2TI0s=";

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
    maintainers = [ ];
    mainProgram = "unimap";
  };
}
