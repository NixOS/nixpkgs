{
  rustPlatform,
  fetchFromGitHub,
  lib,

  installShellFiles,
  stdenv,
  Foundation,
  rust-jemalloc-sys,
}:
let
  version = "25.2.11";

  code_src = fetchFromGitHub {
    owner = "sxyazi";
    repo = "yazi";
    tag = "v${version}";
    hash = "sha256-yVpSoEmEA+/XF/jlJqKdkj86m8IZLAbrxDxz5ZnmP78=";
  };

  man_src = fetchFromGitHub {
    name = "manpages"; # needed to ensure name is unique
    owner = "yazi-rs";
    repo = "manpages";
    rev = "8950e968f4a1ad0b83d5836ec54a070855068dbf";
    hash = "sha256-kEVXejDg4ChFoMNBvKlwdFEyUuTcY2VuK9j0PdafKus=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "yazi";
  inherit version;

  srcs = [
    code_src
    man_src
  ];
  sourceRoot = code_src.name;

  useFetchCargoVendor = true;
  cargoHash = "sha256-AfXi68PNrYj6V6CYIPZT0t2l5KYTYrIzJgrcEPLW8FM=";

  env.YAZI_GEN_COMPLETIONS = true;
  env.VERGEN_GIT_SHA = "Nixpkgs";
  env.VERGEN_BUILD_DATE = "2025-02-11";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ rust-jemalloc-sys ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation ];

  postInstall = ''
    installShellCompletion --cmd yazi \
      --bash ./yazi-boot/completions/yazi.bash \
      --fish ./yazi-boot/completions/yazi.fish \
      --zsh  ./yazi-boot/completions/_yazi

    installManPage ../${man_src.name}/yazi{.1,-config.5}

    install -Dm444 assets/yazi.desktop -t $out/share/applications
    install -Dm444 assets/logo.png $out/share/pixmaps/yazi.png
  '';

  passthru.updateScript.command = [ ./update.sh ];

  meta = {
    description = "Blazing fast terminal file manager written in Rust, based on async I/O";
    homepage = "https://github.com/sxyazi/yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eljamm
      khaneliman
      linsui
      matthiasbeyer
      uncenter
      xyenon
    ];
    mainProgram = "yazi";
  };
}
