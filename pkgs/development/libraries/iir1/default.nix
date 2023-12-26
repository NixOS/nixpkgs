{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iir1";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "berndporr";
    repo = "iir1";
    rev = finalAttrs.version;
    hash = "sha256-T8gl51IkZIGq+6D5ge4Kb3wm5aw7Rhphmnf6TTGwHbs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://berndporr.github.io/iir1/";
    description = "A DSP IIR realtime filter library written in C++";
    downloadPage = "https://github.com/berndporr/iir1";
    changelog = "https://github.com/berndporr/iir1/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
