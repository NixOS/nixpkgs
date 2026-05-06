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
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ChausseBenjamin";
    repo = "termpicker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V1ZwkvlMLTNjk6hdnpByS/7zR7U7kChuKMVP0H+BJD8=";
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
