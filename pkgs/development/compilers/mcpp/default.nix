{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcpp";
  version = "2.7.2.1";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "mcpp";
    rev = finalAttrs.version;
    hash= "sha256-T4feegblOeG+NU+c+PAobf8HT8KDSfcINkRAa1hNpkY=";
  };

  configureFlags = [ "--enable-mcpplib" ];

  meta = with lib; {
    homepage = "https://github.com/museoa/mcpp";
    description = "Matsui's C preprocessor";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
