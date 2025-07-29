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
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "dertuxmalwieder";
    repo = "yaydl";
    rev = "release-${version}";
    sha256 = "sha256-r+UkwEtuGL6los9ohv86KA/3qsaEkpnI4yV/UnYelgk=";
  };

  cargoHash = "sha256-pljSw8iQFV6ymg2GKwI+P7R4jvysyFFC1EM25Wi8Los=";

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
