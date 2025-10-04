{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "elementary-redacted-script";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "fonts";
    rev = version;
    sha256 = "sha256-YiE7yaH0ZrF1/Cp+3bcJYm2cExQjFcat6JLMJPjhops=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/redacted-elementary
    cp -a redacted/*.ttf $out/share/fonts/truetype/redacted-elementary
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Font for concealing text";
    homepage = "https://github.com/elementary/fonts";
    license = licenses.ofl;
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
  };
}
