{
  buildDunePackage,
  zarith,
  ff-sig,
  alcotest,
}:

buildDunePackage {
  pname = "ff-pbt";
  inherit (ff-sig) version src;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  propagatedBuildInputs = [
    zarith
    ff-sig
  ];

  meta = ff-sig.meta // {
    description = "Property based testing library for finite fields over the package ff-sig";
  };
}
