{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zpaq";
  version = "7.15";

  src = fetchFromGitHub {
    owner = "zpaq";
    repo = "zpaq";
    rev = finalAttrs.version;
    sha256 = "0v44rlg9gvwc4ggr2lhcqll8ppal3dk7zsg5bqwcc5lg3ynk2pz4";
  };

  nativeBuildInputs = [
    perl # for pod2man
  ];

  CPPFLAGS = [
    "-Dunix"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isi686 && !stdenv.hostPlatform.isx86_64) "-DNOJIT";
  CXXFLAGS = [
    "-O3"
    "-DNDEBUG"
  ];

  enableParallelBuilding = true;

  makeFlags = [ "CXX=${stdenv.cc.targetPrefix}c++" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Incremental journaling backup utility and archiver";
    homepage = "http://mattmahoney.net/dc/zpaq.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    mainProgram = "zpaq";
  };
})
