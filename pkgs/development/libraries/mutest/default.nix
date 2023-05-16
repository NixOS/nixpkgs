<<<<<<< HEAD
{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, unstableGitUpdater
=======
{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation {
  pname = "mutest";
<<<<<<< HEAD
  version = "0-unstable-2023-02-24";
=======
  version = "unstable-2019-08-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = "mutest";
<<<<<<< HEAD
    rev = "18a20071773f7c4b75e82a931ef9b916b273b3e5";
    sha256 = "z0kASte0/I48Fgxhblu24MjGHidWomhfFOhfStGtPn4=";
=======
    rev = "e6246c9ae4f36ffe8c021f0a80438f6c7a6efa3a";
    sha256 = "0gdqwq6fvk06wld4rhnw5752hahrvhd69zrci045x25rwx90x26q";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

<<<<<<< HEAD
  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    homepage = "https://github.com/ebassi/mutest";
=======
  meta = with lib; {
    homepage = "https://ebassi.github.io/mutest/mutest.md.html";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A BDD testing framework for C, inspired by Mocha";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.all;
  };
}
