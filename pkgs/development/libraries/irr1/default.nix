{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "irr1";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "berndporr";
    repo = "iir1";
    rev = version;
    hash = "sha256-T8gl51IkZIGq+6D5ge4Kb3wm5aw7Rhphmnf6TTGwHbs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A DSP IIR realtime filter library written in C++";
    downloadPage = "https://github.com/berndporr/iir1";
    homepage = "http://berndporr.github.io/iir1/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
}
