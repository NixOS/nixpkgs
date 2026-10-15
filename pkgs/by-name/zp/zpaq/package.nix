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
    hash = "sha256-5F8xrR+PFsY4XuXpf2YbVN2LKMUMUpHfI4zvlx7NhGw=";
  };

  nativeBuildInputs = [
    perl # for pod2man
  ];

  env = {
    CPPFLAGS = toString (
      [
        "-Dunix"
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isi686 && !stdenv.hostPlatform.isx86_64) [
        "-DNOJIT"
      ]
    );
    CXXFLAGS = toString [
      "-O3"
      "-DNDEBUG"
    ];
  };

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
