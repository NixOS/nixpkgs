{
  buildDunePackage,
  dream,
  pure-html,
  ppxlib,
}:

buildDunePackage {
  pname = "dream-html";
  inherit (pure-html) src version meta;

  minimalOCamlVersion = "5.3";

  buildInputs = [
    ppxlib
  ];

  propagatedBuildInputs = [
    pure-html
    dream
  ];
}
