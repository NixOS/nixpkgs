{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  pandoc,
  capstone,
  elfutils,
  libtraceevent,
  ncurses,
  withLuaJIT ? false,
  luajit,
  withPython ? false,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "uftrace";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "sha256-TgGeeZtrhGlQxQp0y6D8SMjRJ9YITzWdaWxblKfcvzU=";
  };

  nativeBuildInputs = [
    pkg-config
    pandoc
  ];
  buildInputs =
    [
      capstone
      elfutils
      libtraceevent
      ncurses
    ]
    ++ lib.optional withLuaJIT luajit
    ++ lib.optional withPython python3;

  # libmcount.so dlopens python and luajit, make sure they're in the RUNPATH
  preBuild =
    let
      libs = lib.optional withLuaJIT "luajit" ++ lib.optional withPython "python3-embed";
    in
    lib.optionalString (withLuaJIT || withPython) ''
      makeFlagsArray+=(LDFLAGS_lib="$(pkg-config --libs ${lib.concatStringsSep " " libs})")
    '';

  postUnpack = ''
    patchShebangs .
  '';

  meta = {
    description = "Function (graph) tracer for user-space";
    mainProgram = "uftrace";
    homepage = "https://github.com/namhyung/uftrace";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nthorne ];
  };
}
