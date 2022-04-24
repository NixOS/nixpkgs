{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2022-04-11";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "2caa26e388b1c904d2f12fb09f84df7e761d8331";
    sha256 = "sha256-TNKHKX/PbrNIQJ+Q50KemfcigEBKe7gmJzTjB6ofYL8=";
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
