{
  lib,
  stdenv,
  fetchurl,
  unixtools,
  groff,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ztools";
  version = "7/3.1";

  src = fetchurl {
    url = "http://mirror.ifarchive.org/if-archive/infocom/tools/ztools/ztools731.tar.gz";
    hash = "sha256-vlQX0/fCAr88KJwMnYUSROFOg9tfVK5Hz58AUDuhNXg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    groff
    unixtools.col
  ];

  # compiler flags as defaults have changed
  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -Wno-implicit-int";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    cp {check,infodump,pix2gif,txd} $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Essential set of Z-machine tools for interpreter authors, experienced Inform programmers, and Z-code hackers";
    homepage = "http://inform-fiction.org/zmachine/ztools.html";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "txd";
  };
})
