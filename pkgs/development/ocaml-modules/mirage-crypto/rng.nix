{ buildDunePackage, mirage-crypto, ounit, randomconv, cstruct }:

buildDunePackage {
  pname = "mirage-crypto-rng";

  inherit (mirage-crypto) version src nativeBuildInputs useDune2 minimumOCamlVersion;

  doCheck = true;
  checkInputs = [ ounit randomconv ];

  propagatedBuildInputs = [ cstruct mirage-crypto ];

  meta = mirage-crypto.meta // {
    description = "A cryptographically secure PRNG";
  };
}
