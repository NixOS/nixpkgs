{ lib, stdenv, fetchFromGitHub, gettext, autoreconfHook, libiconv }:

stdenv.mkDerivation rec {
  pname = "wavpack";
  version = "5.5.0";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv ];

  # autogen.sh:9
  preAutoreconf = "cp ${gettext}/share/gettext/config.rpath .";

  src = fetchFromGitHub {
    owner = "dbry";
    repo = "WavPack";
    rev = version;
    hash = "sha256-4QDtLywu0PT+YsMV26M74bL2P7p4s1tk8ZBQtQcubaU=";
  };

  meta = with lib; {
    description = "Hybrid audio compression format";
    homepage    = "https://www.wavpack.com/";
    changelog   = "https://github.com/dbry/WavPack/releases/tag/${version}";
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
