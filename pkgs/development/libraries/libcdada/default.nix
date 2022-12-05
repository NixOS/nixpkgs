{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libcdada";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "msune";
    repo = "libcdada";
    rev = "v${version}";
    sha256 = "sha256-vUasCukDRZYB67eu87ckEZG9i6rsNf0aKY2kZsVezRE=";
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
