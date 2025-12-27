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
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = "yaydl";
    rev = "release-${version}";
    sha256 = "sha256-mfyh26pft3FnfAAxXBpOBCTJ4HATUmrCvaN+HAiDHGc=";
  };

  cargoHash = "sha256-iVhaIkJeaofMLlvBrJZtAJ4SsBb1VBdMg6XoZhjGV5g=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ];

  postInstall = ''
    wrapProgram $out/bin/yaydl \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = {
    homepage = "https://code.rosaelefanten.org/yaydl";
    description = "Yet another youtube down loader";
    license = lib.licenses.cddl;
    maintainers = [ ];
    mainProgram = "yaydl";
  };
}
