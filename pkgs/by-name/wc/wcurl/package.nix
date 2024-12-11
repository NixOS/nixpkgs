{
  stdenvNoCC,
  lib,
  coreutils,
  curl,
  fetchFromGitHub,
  gnused,
  installShellFiles,
  nix-update-script,
  makeBinaryWrapper,
  shunit2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wcurl";
  version = "2024.12.08";

  src = fetchFromGitHub {
    owner = "curl";
    repo = "wcurl";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-X6v03oYb/n9ALJXpx5HQojths7tv1rEftGUiQElv7aY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  nativeCheckInputs = [ shunit2 ];

  doCheck = true;

  dontBuild = true;

  postPatch = ''
    substituteInPlace wcurl \
      --replace-fail '"curl "' '"${curl}/bin/curl "'
  '';

  checkPhase = ''
    runHook preCheck

    tests/tests.sh

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -D wcurl -t $out/bin
    installManPage wcurl.1

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/wcurl \
      --inherit-argv0 \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://curl.se/wcurl";
    description = "Simple wrapper around curl to easily download files";
    mainProgram = "wcurl";
    license = lib.licenses.curl;
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.all;
  };
})
