{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  gitUpdater,
  unicode-character-database,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "unicode-paracode";
  version = "3.2-unstable-2025-01-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "7df103ee988bbfe999f457e23cbc0e954dd0e813";
    hash = "sha256-4u/tp+KQMfgo8zS4INB8MJBOLgHqMBj3Tk2yj7Sp3YU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python3Packages; [ setuptools ];

  postFixup = ''
    mkdir -p "$out/share/unicode"
    ln -s "${unicode-character-database}/share/unicode/UnicodeData.txt" "$out/share/unicode/UnicodeData.txt"
    # We want to keep /usr/share/unicode in the list for the Unihan files
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace-fail "'/usr/share/unicode', " "'$out/share/unicode', '/usr/share/unicode', "
  '';

  postInstall = ''
    installManPage paracode.1 unicode.1
  '';

  checkPhase = ''
    runHook preCheck

    echo Testing: $out/bin/unicode --brief z
    diff -u <(echo z U+007A LATIN SMALL LETTER Z) <($out/bin/unicode --brief z 2>&1) && echo Success

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Display unicode character properties";
    homepage = "https://github.com/garabik/unicode";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.woffs ];
    mainProgram = "unicode";
    platforms = lib.platforms.all;
  };
})
