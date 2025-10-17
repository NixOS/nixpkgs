{
  buildDunePackage,
  raven,
  raven-nx,
  openblas,
  alcotest,
  re,
  uucp,
  uutf,
  yojson,
}:

buildDunePackage {
  pname = "saga";

  inherit (raven) version src sandboxProfile;

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
    openblas.dev
  ];

  meta = raven.meta // {
    description = "Text processing and NLP extensions for Nx";
    longDescription = ''
      Text processing library that extends Nx with natural language processing capabilities.
      Provides tokenization, encoding, and text manipulation functionality compatible with the Nx tensor library.
    '';
  };
}
