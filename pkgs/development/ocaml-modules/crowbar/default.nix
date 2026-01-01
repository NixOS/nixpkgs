{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  ocplib-endian,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmdliner,
  afl-persistent,
  calendar,
  fpath,
  pprint,
  uutf,
  uunf,
  uucp,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "crowbar";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "stedolan";
    repo = "crowbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KGDOm9PMymFwyHoe7gp+rl+VxbbkLvnb8ypTXbImSgs=";
  };

=======
buildDunePackage rec {
  pname = "crowbar";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "stedolan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0jjwiOZ9Ut+dv5Iw4xNvf396WTehT1VClxY9VHicw4U=";
  };

  minimalOCamlVersion = "4.08";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # disable xmldiff tests, so we don't need to package unmaintained and legacy pkgs
  postPatch = "rm -rf examples/xmldiff";

  propagatedBuildInputs = [
<<<<<<< HEAD
=======
    ocplib-endian
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cmdliner
    afl-persistent
  ];
  checkInputs = [
    calendar
    fpath
    pprint
    uutf
    uunf
    uucp
  ];
  # uunf is broken on aarch64
  doCheck = !stdenv.hostPlatform.isAarch64;

<<<<<<< HEAD
  meta = {
    description = "Property fuzzing for OCaml";
    homepage = "https://github.com/stedolan/crowbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
=======
  meta = with lib; {
    description = "Property fuzzing for OCaml";
    homepage = "https://github.com/stedolan/crowbar";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
