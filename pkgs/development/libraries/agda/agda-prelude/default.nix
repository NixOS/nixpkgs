{
  lib,
  mkDerivation,
  fetchFromGitHub,
  unstableGitUpdater,
}:

mkDerivation {
  version = "0-unstable-2024-08-22";
  pname = "agda-prelude";

  src = fetchFromGitHub {
    owner = "UlfNorell";
    repo = "agda-prelude";
    rev = "4230566d3ae229b6a00258587651ac7bfd38d088";
    hash = "sha256-ab+KojzRbkUTAFNH5OA78s0F5SUuXTbliai6badveg4=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/UlfNorell/agda-prelude";
    description = "Programming library for Agda";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mudri
      alexarice
      turion
    ];
  };
}
