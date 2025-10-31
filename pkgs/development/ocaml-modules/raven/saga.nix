{
  buildDunePackage,
  alcotest,
  raven,
  raven-nx,
  re,
  uucp,
  uutf,
  yojson,
}:

buildDunePackage {
  pname = "saga";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    raven-nx
    re
    uucp
    uutf
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
