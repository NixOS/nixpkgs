{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "zalgo";
  version = "0-unstable-2020-08-26";

  src = fetchFromGitHub {
    owner = "lunasorcery";
    repo = "zalgo";
    rev = "6aa1f66cfe183f8164a666730dfeaf39133cf01a";
    hash = "sha256-nIjWckoNOyfKgtGeQ02reEcYf9yTZUp5Qk5I5rY3BQM=";
  };

  installPhase = ''
    install -Dm755 zalgo -t $out/bin
  '';

  meta = {
    description = "Read stdin and corrupt it with combining diacritics";
    homepage = "https://github.com/lunasorcery/zalgo";
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ djanatyn ];
    mainProgram = "zalgo";
  };
}
