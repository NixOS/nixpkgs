{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libcdada";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "msune";
    repo = "libcdada";
    rev = "v${version}";
    sha256 = "0vcsf3s4fbw2w33jjc8b509kc0xb6ld58l8wfxgqwjqx5icfg1ps";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--without-tests"
    "--without-examples"
  ];

  meta = with lib; {
    description = "Library for basic data structures in C";
    longDescription = ''
      Basic data structures in C: list, set, map/hashtable, queue... (libstdc++ wrapper)
    '';
    homepage = "https://github.com/msune/libcdada";
    license = licenses.bsd2;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.unix;
  };
}
