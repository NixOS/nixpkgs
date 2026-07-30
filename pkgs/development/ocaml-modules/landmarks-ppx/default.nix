{
  buildDunePackage,
  landmarks,
  ppxlib,
}:

buildDunePackage {
  pname = "landmarks-ppx";

  minimalOCamlVersion = "5.3";

  inherit (landmarks) src version;

  buildInputs = [ ppxlib ];
  propagatedBuildInputs = [ landmarks ];

  doCheck = true;

  meta = landmarks.meta // {
    description = "Preprocessor instrumenting code using the landmarks library";
    longDescription = ''
      Automatically or semi-automatically instrument your code using
      landmarks library.
    '';
  };
}
