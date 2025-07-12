{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  installShellFiles,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "unicode";
  version = "2.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "v${version}";
    sha256 = "sha256-FHAlZ5HID/FE9+YR7Dmc3Uh7E16QKORoD8g9jgTeQdY=";
  };

  ucdtxt = fetchurl {
    url = "https://www.unicode.org/Public/16.0.0/ucd/UnicodeData.txt";
    sha256 = "sha256-/1jlgjvQlRZlZKAG5H0RETCBPc+L8jTvefpRqHDttI8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postFixup = ''
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace "/usr/share/unicode/UnicodeData.txt" "$ucdtxt"
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
