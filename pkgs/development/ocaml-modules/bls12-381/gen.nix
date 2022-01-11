{ lib, fetchFromGitLab, buildDunePackage, ff-sig, zarith }:

buildDunePackage rec {
  pname = "bls12-381-gen";
  version = "0.4.2";

  src = fetchFromGitLab {
      owner = "dannywillems";
      repo = "ocaml-bls12-381";
      rev = version;
      sha256 = "0jxc8qrdn74brmzjns1xycv3cb257kx5pa3ripgl9ci4njkv87n2";
  };
  useDune2 = true;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    ff-sig
    zarith
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "Functors to generate BLS12-381 primitives based on stubs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
