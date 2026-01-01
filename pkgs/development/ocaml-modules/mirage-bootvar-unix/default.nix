{
  lib,
  fetchurl,
  buildDunePackage,
  lwt,
  parse-argv,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "mirage-bootvar-unix";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-bootvar-unix/releases/download/${finalAttrs.version}/mirage-bootvar-unix-${finalAttrs.version}.tbz";
    hash = "sha256-buVLmVBElmoZELZHDXAMxUUSIwT3KDBGZOB1e7zRImU=";
=======
buildDunePackage rec {
  pname = "mirage-bootvar-unix";
  version = "0.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-bootvar-unix/releases/download/${version}/mirage-bootvar-unix-${version}.tbz";
    sha256 = "0r92s6y7nxg0ci330a7p0hii4if51iq0sixn20cnm5j4a2clprbf";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    lwt
    parse-argv
  ];

  meta = {
    description = "Unix implementation of MirageOS Bootvar interface";
    homepage = "https://github.com/mirage/mirage-bootvar-unix";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
