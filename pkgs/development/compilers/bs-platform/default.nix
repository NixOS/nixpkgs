{ stdenv, fetchFromGitHub, ninja, nodejs, python3, ... }:
let
  meta = with stdenv.lib; {
    description = "A JavaScript backend for OCaml focused on smooth integration and clean generated code.";
    homepage = https://bucklescript.github.io;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ turbomack gamb ];
    platforms = platforms.all;
  };
in
{
  bs-platform-621 = import ./bs-platform-62.nix {
    inherit stdenv fetchFromGitHub ninja nodejs python3;
  } // { inherit meta; };
}
