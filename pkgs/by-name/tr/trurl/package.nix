{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  python3,
  perl,
  trurl,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "trurl";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "curl";
    repo = "trurl";
    rev = "trurl-${version}";
    hash = "sha256-VCMT4WgZ6LG7yiKaRy7KTgTkbACVXb4rw62lWnVAuP0=";
  };

  postPatch = ''
    patchShebangs scripts/*
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    curl
    perl
  ];
  buildInputs = [ curl ];
  makeFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  doCheck = true;
  nativeCheckInputs = [ python3 ];
  checkTarget = "test";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Command line tool for URL parsing and manipulation";
    homepage = "https://curl.se/trurl";
    changelog = "https://github.com/curl/trurl/releases/tag/trurl-${version}";
    license = lib.licenses.curl;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    platforms = lib.platforms.all;
    mainProgram = "trurl";
  };
}
