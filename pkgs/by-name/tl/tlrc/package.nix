{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-SoWGZXBAqWWg5kwwpWuiA7iGqq9RNok/LqsjPAy6O+k=";
  };

  cargoHash = "sha256-+HxRu8t6nofeE9WrDxQhebWIgeMYeMSXnHtHR1OHGzw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage tldr.1
    installShellCompletion completions/{tldr.bash,_tldr,tldr.fish}
  '';

  meta = with lib; {
    description = "Official tldr client written in Rust";
    homepage = "https://github.com/tldr-pages/tlrc";
    changelog = "https://github.com/tldr-pages/tlrc/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "tldr";
    maintainers = with maintainers; [ acuteenvy ];
  };
}
