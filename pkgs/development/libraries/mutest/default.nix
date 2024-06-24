{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "mutest";
  version = "0-unstable-2023-02-24";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = "mutest";
    rev = "18a20071773f7c4b75e82a931ef9b916b273b3e5";
    sha256 = "z0kASte0/I48Fgxhblu24MjGHidWomhfFOhfStGtPn4=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    homepage = "https://github.com/ebassi/mutest";
    description = "BDD testing framework for C, inspired by Mocha";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.all;
  };
}
