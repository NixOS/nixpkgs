{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  openssl,
  ffmpeg,
}:

rustPlatform.buildRustPackage rec {
  pname = "yaydl";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = "yaydl";
    rev = "release-${version}";
    sha256 = "sha256-PSrLjqZ38gBlTiV6qMB3LzrcaqtM6hnZMI1uto24H94=";
  };

  cargoHash = "sha256-+BBB9YbYjNG7S+Lex/pwp7z06JbG+qMRI+TwSvMcYgg=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ];

  postInstall = ''
    wrapProgram $out/bin/yaydl \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    homepage = "https://code.rosaelefanten.org/yaydl";
    description = "Yet another youtube down loader";
    license = licenses.cddl;
    maintainers = [ ];
    mainProgram = "yaydl";
  };
}
