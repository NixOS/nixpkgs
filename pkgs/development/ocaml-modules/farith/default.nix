{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  ppx_deriving,
  ppx_hash,
  zarith,
}:

buildDunePackage rec {
  pname = "farith";
  version = "0.1";

  minimalOCamlVersion = "4.10";

  src = fetchFromGitLab {
    domain = "git.frama-c.com";
    owner = "pub";
    repo = "farith";
    tag = version;
    hash = "sha256-9TGKeL3DXKEf2RLpkjOTC8aDQeLKSM9QUIiSkFCQW+8=";
  };

  propagatedBuildInputs = [
    ppx_deriving
    ppx_hash
    zarith
  ];

  doCheck = true;

  meta = {
    description = "Modelisation of base 2 floating points with arbitrary exponent and mantisse size.";
    homepage = "https://git.frama-c.com/pub/farith";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
