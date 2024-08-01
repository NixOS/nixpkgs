{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, calibre
}:

rustPlatform.buildRustPackage rec {
  pname = "unbook";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "ludios";
    repo = "unbook";
    rev = version;
    hash = "sha256-THCPJ4zOKSXKZDa5DuqpBfBKZ96TdFEuDMVw/HmO7Eo=";
  };

  cargoHash = "sha256-EbSayNz9cPmMDQOaOiyQAYmtlnb+4jzbffm1On0BBxI=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/unbook --prefix PATH : ${lib.makeBinPath [ calibre ]}
  '';

  meta = with lib; {
    description = "Ebook to self-contained-HTML converter";
    homepage = "https://unbook.ludios.org";
    license = licenses.cc0;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "unbook";
  };
}
