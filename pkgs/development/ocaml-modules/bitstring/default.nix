{ lib, fetchFromGitHub, buildDunePackage, stdlib-shims }:

buildDunePackage rec {
  pname = "bitstring";
<<<<<<< HEAD
  version = "4.1.1";
=======
  version = "4.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "xguerin";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-eO7/S9PoMybZPnQQ+q9qbqKpYO4Foc9OjW4uiwwNds8=";
=======
    sha256 = "0mghsl8b2zd2676mh1r9142hymhvzy9cw8kgkjmirxkn56wbf56b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = with lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = "https://github.com/xguerin/bitstring";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
