{
  lib,
  fetchFromGitHub,
  rustPlatform,
  go,
  buildGoModule,
}:

rustPlatform.buildRustPackage {
  pname = "you-have-mail-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "LeanderBB";
    repo = "you-have-mail-cli";
    rev = "b338153353495428e2dc0065843553b7821b9d3a";
    hash = "sha256-YgIztCmL+uJUUXu+BWXLf9f4L7UpuPf0onsfMRtlWkw=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    go
  ];

  goSrpVersion = "0.1.5";
  postPatch = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    export GOPROXY=off
    cp -r --reflink=auto "$goModules" "$cargoDepsCopy/go-srp-$goSrpVersion/go/vendor"
  '';

  goModules =
    (buildGoModule {
      pname = "proton-api-rs";
      version = "0.14.0";
      src = fetchFromGitHub {
        owner = "LeanderBB";
        repo = "proton-api-rs";
        rev = "4597810e8335118f3c780a04e6d099ae46a7a376";
        hash = "sha256-PN5+D8PY7ouhvoyhu0X0PsgF8tgptl80cF0w2u8nUqs=";
      };
      modRoot = "./go-srp/go/";
      vendorHash = "sha256-QPj2jq8hWL4kZellM/VwqrO/Oku/JW1Cig1Iv5YSI1U=";
    }).goModules;

  cargoHash = "sha256-w2hrrFHpgeAPcP/swerZu0VJ34T/9/JeQkipp4IQ2js=";

  meta = {
    description = "Small application to notify you when you receive an email in your email account";
    homepage = "https://github.com/LeanderBB/you-have-mail-cli";
    license = lib.licenses.agpl3Only;
    mainProgram = "you-have-mail-cli";
    maintainers = with lib.maintainers; [ baksa ];
  };
}
