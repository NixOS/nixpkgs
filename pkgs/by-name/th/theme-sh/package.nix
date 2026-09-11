{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "theme-sh";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "lemnos";
    repo = "theme.sh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-zDw8WGBzO4/HRCgN7yoUxT49ibTz+QkRa5WpBQbl1nI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 bin/theme.sh $out/bin
    wrapProgram $out/bin/theme.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Script which lets you set your $terminal theme";
    homepage = "https://github.com/lemnos/theme.sh";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "theme.sh";
  };
})
