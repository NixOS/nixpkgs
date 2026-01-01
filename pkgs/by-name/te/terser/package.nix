{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
<<<<<<< HEAD
  version = "5.44.1";
=======
  version = "5.44.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Z4ZdCSGqyu7jjpLgHEZCvrZj+IsqEbdcjATdy80TnC8=";
  };

  npmDepsHash = "sha256-Zmbh/NMriZtkYpFd5hCJo+nPrKTrqYfh3W+sZpopBHM=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
=======
    hash = "sha256-3dYczeq3ZGzA4E07lJfuR7039U+LaxVbWGlfMF9+iiY=";
  };

  npmDepsHash = "sha256-jec/XyYDGhvl3fngG/HGJMI1G5JtYuZi/pJFrZuir+A=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
