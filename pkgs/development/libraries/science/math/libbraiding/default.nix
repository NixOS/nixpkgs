{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "1.1";
  pname = "libbraiding";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libbraiding";
    rev = version;
    sha256 = "1n1j58y9jaiv0ya0y4fpfb3b05wv0h6k2babpnk2zifjw26xr366";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  # no tests included for now (2018-08-05), but can't hurt to activate
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/miguelmarco/libbraiding/";
    description = "C++ library for computations on braid groups";
    longDescription = ''
      A library to compute several properties of braids, including centralizer and conjugacy check.
    '';
    license = licenses.gpl3;
    maintainers = teams.sage.members;
    platforms = platforms.all;
  };
}
