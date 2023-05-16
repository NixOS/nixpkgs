{ lib, stdenv, fetchFromGitHub, gettext, autoreconfHook, libiconv }:

stdenv.mkDerivation rec {
  pname = "wavpack";
<<<<<<< HEAD
  version = "5.6.0";
=======
  version = "5.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv ];

  # autogen.sh:9
  preAutoreconf = "cp ${gettext}/share/gettext/config.rpath .";

  src = fetchFromGitHub {
    owner = "dbry";
    repo = "WavPack";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-fWAGE87JTNTnYoxrkMf3I8C53kZrQiiBy3Zyg0cw8Og=";
=======
    hash = "sha256-4QDtLywu0PT+YsMV26M74bL2P7p4s1tk8ZBQtQcubaU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" "doc" "man" ];

  meta = with lib; {
    description = "Hybrid audio compression format";
    homepage    = "https://www.wavpack.com/";
    changelog   = "https://github.com/dbry/WavPack/releases/tag/${version}";
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
