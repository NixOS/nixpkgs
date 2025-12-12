{
  buildDunePackage,
  dream,
  pure-html,
  ppxlib,
}:

buildDunePackage {
  pname = "dream-html";
  inherit (pure-html) src version meta;

  buildInputs = [
    ppxlib
  ];

  propagatedBuildInputs = [
    pure-html
    dream
  ];
}
