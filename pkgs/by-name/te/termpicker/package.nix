{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "termpicker";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ChausseBenjamin";
    repo = "termpicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tUmd+GotimE8CrL6sJG7+uREnZAUsd2fEkH31575hFc=";
  };

  vendorHash = "sha256-M5YZaJdv9D8NkwD+T8tAtGH5P4IKcgjqpUoKVfLo+C0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/termpicker docs --format man > termpicker.1
    installManPage termpicker.1
  '';

  __structuredAttrs = true;

  meta = {
    description = "A color picker for the terminal";
    homepage = "https://github.com/ChausseBenjamin/termpicker";
    license = lib.licenses.beerware;
    mainProgram = "termpicker";
    maintainers = with lib.maintainers; [ k2on ];
  };
})
