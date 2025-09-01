{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  calibre,
  gitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "unbook";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ludios";
    repo = "unbook";
    rev = version;
    hash = "sha256-whWWh/jQ4RkGA3T1VCmt6zhpQQCzh2jASYg69IlfEeo=";
  };

  cargoHash = "sha256-r4RWcz7TSP7wfo9mu8wfOyy7C4PIWkrSt4RyDY3/lQA=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/unbook --prefix PATH : ${lib.makeBinPath [ calibre ]}
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Ebook to self-contained-HTML converter";
    homepage = "https://unbook.ludios.org";
    license = licenses.cc0;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "unbook";
  };
}
