{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, boost
, libbacktrace
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libsegfault";
  version = "unstable-2022-11-13";

  src = fetchFromGitHub {
    owner = "jonathanpoelen";
    repo = "libsegfault";
    rev = "8bca5964613695bf829c96f7a3a14dbd8304fe1f";
    sha256 = "vKtY6ZEkyK2K+BzJCSo30f9MpERpPlUnarFIlvJ1Giw=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin) "-DBOOST_STACKTRACE_GNU_SOURCE_NOT_REQUIRED=1";

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    boost
    libbacktrace
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Implementation of libSegFault.so with Boost.stracktrace";
    homepage = "https://github.com/jonathanpoelen/libsegfault";
    license = licenses.asl20;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
