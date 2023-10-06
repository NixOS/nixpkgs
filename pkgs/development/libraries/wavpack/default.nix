{ lib, stdenv, fetchFromGitHub, gettext, autoreconfHook, libiconv }:

stdenv.mkDerivation rec {
  pname = "wavpack";
  version = "5.6.0";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv ];

  # autogen.sh:9
  preAutoreconf = "cp ${gettext}/share/gettext/config.rpath .";

  src = fetchFromGitHub {
    owner = "dbry";
    repo = "WavPack";
    rev = version;
    hash = "sha256-fWAGE87JTNTnYoxrkMf3I8C53kZrQiiBy3Zyg0cw8Og=";
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
