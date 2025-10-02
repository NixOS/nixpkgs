{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    hash = "sha256-GZN7WE12f3MEoBfswag0O04UOCmZeYwt5CbYwddmwHs=";
  };

  cargoHash = "sha256-Zk2L4cq7j9CkSc+cnZRWwhtfWP6y5faiMVGFFNkBwwA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd tldr \
      --bash completion/bash_tealdeer \
      --fish completion/fish_tealdeer \
      --zsh completion/zsh_tealdeer
  '';

  # Disable tests that require Internet access:
  checkFlags = [
    "--skip test_autoupdate_cache"
    "--skip test_create_cache_directory_path"
    "--skip test_pager_flag_enable"
    "--skip test_quiet_cache"
    "--skip test_quiet_failures"
    "--skip test_quiet_old_cache"
    "--skip test_spaces_find_command"
    "--skip test_update_cache"
  ];

  meta = with lib; {
    description = "Very fast implementation of tldr in Rust";
    homepage = "https://github.com/dbrgn/tealdeer";
    maintainers = with maintainers; [
      davidak
      newam
      mfrw
      ryan4yin
    ];
    license = with licenses; [
      asl20
      mit
    ];
    mainProgram = "tldr";
  };
}
