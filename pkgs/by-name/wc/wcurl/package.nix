{
  stdenvNoCC,
  lib,
  curl,
  fetchFromGitLab,
  installShellFiles,
  nix-update-script,
  shunit2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wcurl";
  version = "2024.07.10";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "wcurl";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-FYkG74uoXFNYT7tszDcdCPQCEG3ePOFBUgIUYpsAzb8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ installShellFiles ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://salsa.debian.org/debian/wcurl";
    description = "Simple wrapper around curl to easily download files";
    mainProgram = "wcurl";
    license = lib.licenses.curl;
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.all;
  };
})
