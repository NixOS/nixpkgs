{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  jq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsv";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6Gc9RDrQmayTnCoFHYN8B3gdqR3CPyyLWtO31WpnJ3o=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ jq ];

  configureFlags = [
    "--jq-prefix=${lib.getLib jq}"
  ];

  meta = {
    description = "World's fastest (simd) CSV parser, with an extensible CLI";
    mainProgram = "zsv";
    homepage = "https://github.com/liquidaty/zsv";
    changelog = "https://github.com/liquidaty/zsv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
