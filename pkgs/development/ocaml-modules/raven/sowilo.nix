{
  buildDunePackage,
  raven,
  raven-rune,
  windtrap,
  mdx,
  logs,
}:

buildDunePackage {
  pname = "sowilo";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    raven-rune
  ];

  doCheck = true;

  nativeCheckInputs = [
    mdx.bin
    (mdx.override { inherit logs; })
  ];

  checkInputs = [
    windtrap
    mdx
  ];

  meta = raven.meta // {
    description = "Computer vision extensions for Rune";
    longDescription = ''
      Computer vision operations and algorithms built on top of the Rune library.
      Provides image processing, feature extraction, and other vision-related functionality.
    '';
  };
}
