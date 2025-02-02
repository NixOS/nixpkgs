{
  stdenvNoCC,
  fetchFromGitHub,
  theme,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruppled-lite-cursors";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-adCXYu8v6mFKXubVQb/RCZXS87//YgixQp20kMt7KT8=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/${theme}
    cp -r ${theme}/{cursors,index.theme} $out/share/icons/${theme}
  '';

  meta = with lib; {
    description = "Gruppled Lite Cursors theme";
    homepage = "https://github.com/nim65s/gruppled-lite-cursors";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nim65s ];
  };
})
