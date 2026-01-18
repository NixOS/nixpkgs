{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  installShellFiles,
  gitUpdater,
  unicode-character-database,
}:

python3Packages.buildPythonApplication rec {
  pname = "unicode";
  version = "2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "v${version}";
    sha256 = "sha256-FHAlZ5HID/FE9+YR7Dmc3Uh7E16QKORoD8g9jgTeQdY=";
  };

  patches = [
    # Fix 3.13+ mutable locals()
    (fetchurl {
      url = "https://github.com/garabik/unicode/commit/412952b9b4730263f5b560924b84f8934ea4ba21.patch";
      hash = "sha256-Rfm6Jc7V5n7ggQzA/yeDrYedGMWqRkeUX6FRCUkBWcI=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python3Packages; [ setuptools ];

  postFixup = ''
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace-fail "/usr/share/unicode/UnicodeData.txt" "${unicode-character-database}/share/unicode/UnicodeData.txt"
  '';

  postInstall = ''
    installManPage paracode.1 unicode.1
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Display unicode character properties";
    homepage = "https://github.com/garabik/unicode";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.woffs ];
    platforms = lib.platforms.all;
  };
}
