{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  pname = "brigand";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "edouarda";
    repo = "brigand";
    rev = "4db9f665b4ece31b51aaf35b499b2c8e5811efa3";
    sha256 = "14b8r3s24zq0l3addy3irzxs5cyqn3763y5s310lmzzswgj1v7r4";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Instant compile time C++ 11 metaprogramming library";
    longDescription = ''
      Brigand is a light-weight, fully functional, instant-compile time C++ 11 meta-programming library.
      Everything you were doing with Boost.MPL can be done with Brigand. And if that's not the case, open an issue!'';
    homepage = "https://github.com/edouarda/brigand";
    license = licenses.boost;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.all;
  };
}
