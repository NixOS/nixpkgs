{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xxhash";
  version = "0.8.4";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YbWK23lU2/DiKQFPWioMHLgEt8vBtDpjBakT9ds3XpI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeDir = "../build/cmake";

  meta = {
    description = "Extremely fast hash algorithm";
    longDescription = ''
      xxHash is an Extremely fast Hash algorithm, running at RAM speed limits.
      It successfully completes the SMHasher test suite which evaluates
      collision, dispersion and randomness qualities of hash functions. Code is
      highly portable, and hashes are identical on all platforms (little / big
      endian).
    '';
    homepage = "https://github.com/Cyan4973/xxHash";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
    mainProgram = "xxhsum";
    maintainers = [ ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "libxxhash"
    ];
  };
})
