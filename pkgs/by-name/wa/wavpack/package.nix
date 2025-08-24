{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  autoreconfHook,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "wavpack";
  version = "5.8.1";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    gettext
  ];
  buildInputs = [ libiconv ];

  src = fetchFromGitHub {
    owner = "dbry";
    repo = "WavPack";
    rev = version;
    hash = "sha256-V9jRIuDpZYIBohJRouGr2TI32BZMXSNVfavqPl56YO0=";
  };

  patches = [ ./Fix-autoreconf-with-gettext-0.25.patch ];

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  meta = {
    description = "Hybrid audio compression format";
    homepage = "https://www.wavpack.com/";
    changelog = "https://github.com/dbry/WavPack/releases/tag/${version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ codyopel ];
  };
}
