{
  lib,
  stdenv,
  fetchFromCodeberg,
  libxcursor,
  libx11,
  libxrender,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sxcs";
  version = "1.2.1";

  src = fetchFromCodeberg {
    owner = "NRK";
    repo = "sxcs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Dz14gARdiHZApT20PGS5pop327XROBeAXeKUeHo7iA=";
  };

  buildInputs = [
    libx11
    libxcursor
    libxrender
  ];
  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    ${stdenv.cc.targetPrefix}cc -o sxcs sxcs.c -O3 -s -l X11 -l Xcursor -l Xrender
    runHook postBuild
  '';

  outputs = [
    "out"
    "man"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sxcs -t $out/bin
    installManPage sxcs.1

    runHook postInstall
  '';

  meta = {
    description = "Minimal X11 Color Picker and Magnifier";
    homepage = "https://codeberg.org/NRK/sxcs";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
  };
})
