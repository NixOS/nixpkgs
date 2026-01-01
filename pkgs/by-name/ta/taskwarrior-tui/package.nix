{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
<<<<<<< HEAD
  version = "0.26.5";
=======
  version = "0.26.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-mdkGRxe9d92WXBCLhBUWNALS4WwjoeYgZop2frZwNN0=";
  };

  cargoHash = "sha256-Z9y8LLqTicbw4Q+lFalQo4kZFddU2fVMBl6iR4f6D9g=";
=======
    sha256 = "sha256-Ubl2xSFb5ZJ/5JqNI0In3hX6SxZd4g/AEq+CLdN2FsE=";
  };

  cargoHash = "sha256-lq2mqMrhcRX2gX7youx8NrZEKmEOJYuhIsHHixuQmmk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  # Because there's a test that requires terminal access
  doCheck = false;

  postInstall = ''
    installManPage docs/taskwarrior-tui.1
    installShellCompletion completions/taskwarrior-tui.{bash,fish} --zsh completions/_taskwarrior-tui
  '';

<<<<<<< HEAD
  meta = {
    description = "Terminal user interface for taskwarrior";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
=======
  meta = with lib; {
    description = "Terminal user interface for taskwarrior";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "taskwarrior-tui";
  };
}
