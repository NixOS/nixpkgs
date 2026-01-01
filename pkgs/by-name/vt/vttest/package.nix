{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20241208";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/vttest/vttest-${version}.tgz"
<<<<<<< HEAD
      "https://invisible-island.net/archives/vttest/vttest-${version}.tgz"
=======
      "ftp://ftp.invisible-island.net/vttest/vttest-${version}.tgz"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    sha256 = "sha256-j+47rH6H1KpKIXvSs4q5kQw7jPmmBbRQx2zMCtKmUZ0=";
  };

<<<<<<< HEAD
  meta = {
    description = "Tests the compatibility of so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Tests the compatibility of so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "vttest";
  };
}
