{
  stdenvNoCC,
  fetchFromGitHub,
  theme,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruppled-cursors";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "gruppled-cursors";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ejlgdogjIYevZvB23si6bEeU6qY7rWXflaUyVk5MzqU=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/${theme}
    cp -r ${theme}/{cursors,index.theme} $out/share/icons/${theme}
  '';

  meta = with lib; {
    description = "Gruppled Cursors theme";
    homepage = "https://github.com/nim65s/gruppled-cursors";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nim65s ];
  };
})
