{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
  wl-clipboard,
}:

buildGoModule (finalAttrs: {
  pname = "termpicker";
  version = "1.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ChausseBenjamin";
    repo = "termpicker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tUmd+GotimE8CrL6sJG7+uREnZAUsd2fEkH31575hFc=";
  };

  vendorHash = "sha256-M5YZaJdv9D8NkwD+T8tAtGH5P4IKcgjqpUoKVfLo+C0=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  propagatedUserEnvPkgs = [ wl-clipboard ];

  postInstall = ''
    rm $out/bin/documentation
    mkdir --parents $out/share/man/man1
    go run ./internal/documentation > $out/share/man/man1/termpicker.1

    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Color picker for the terminal";
    homepage = "https://github.com/ChausseBenjamin/termpicker";
    license = lib.licenses.beerware;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "termpicker";
  };
})
