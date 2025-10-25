{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "within";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "sjmulder";
    repo = "within";
    tag = finalAttrs.version;
    hash = "sha256-UyOgEe07K1LW5IbB7ngxelp+9Njq/NPPkWw3sxAQyVY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/sjmulder/within";
    description = "Run a command in other directories";
    changelog = "https://github.com/sjmulder/within/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.examosa ];
    platforms = lib.platforms.all;
    mainProgram = "within";
  };
})
