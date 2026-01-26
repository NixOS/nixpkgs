{
  buildDunePackage,
  alcotest,
  raven,
  raven-rune,
}:

buildDunePackage {
  pname = "sowilo";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    raven-rune
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];

  meta = raven.meta // {
    description = "Computer vision extensions for Rune";
    longDescription = ''
      Computer vision operations and algorithms built on top of the Rune library.
      Provides image processing, feature extraction, and other vision-related functionality.
    '';
  };
}
