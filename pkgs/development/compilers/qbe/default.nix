{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2021-11-22";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "bf153b359e9ce3ebef9bca899eb7ed5bd9045c11";
    sha256 = "sha256-13Mvq4VWZxlye/kncJibCnfSECx4PeHMYLuX0xMkN3A=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru = {
    tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
