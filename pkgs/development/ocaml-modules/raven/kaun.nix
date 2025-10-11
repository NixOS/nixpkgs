{
  buildDunePackage,
  raven,
  raven-nx-datasets,
  raven-saga,
  raven-rune,
  domainslib,
  alcotest,
  yojson,
}:

buildDunePackage {
  pname = "kaun";

  inherit (raven) version src sandboxProfile;

  propagatedBuildInputs = [
    raven-nx-datasets
    raven-saga
    raven-rune
    domainslib
    yojson
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = raven.meta // {
    description = "Text processing and NLP extensions for Nx";
    longDescription = ''
      Text processing library that extends Nx with natural language processing capabilities.
      Provides tokenization, encoding, and text manipulation functionality compatible with the Nx tensor library.
    '';
  };
}
