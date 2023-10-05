{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, calibre
}:

rustPlatform.buildRustPackage rec {
  pname = "unbook";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "ludios";
    repo = "unbook";
    rev = version;
    hash = "sha256-KYnSIT/zIrbDFRWIaQRto0sPPmpJC8V7f00j4t/AsGQ=";
  };

  cargoHash = "sha256-AjyeTFgjl3XLplo8w9jne5FyKd2EciwbAKKiaDshpcA=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/unbook --prefix PATH : ${lib.makeBinPath [ calibre ]}
  '';

  meta = with lib; {
    description = "An ebook to self-contained-HTML converter";
    homepage = "https://unbook.ludios.org";
    license = licenses.cc0;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "unbook";
  };
}
