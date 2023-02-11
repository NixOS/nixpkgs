{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (self: {
  pname = "irr1";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "berndporr";
    repo = "iir1";
    rev = self.version;
    hash = "sha256-T8gl51IkZIGq+6D5ge4Kb3wm5aw7Rhphmnf6TTGwHbs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "http://berndporr.github.io/iir1/";
    description = "A DSP IIR realtime filter library written in C++";
    changelog = "https://github.com/berndporr/iir1/releases/tag/${self.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
