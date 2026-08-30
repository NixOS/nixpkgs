{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  astring,
  fmt,
  tyxml,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "ansi";
  version = "0.7.0";

  minimalOCamlVersion = "4.10";

  src = fetchFromGitHub {
    owner = "ocurrent";
    repo = "ansi";
    tag = finalAttrs.version;
    hash = "sha256-VZR8hz2v4gAvTkizBt59DSYr3tGPWT1Iid8m8YQx48Y=";
  };

  propagatedBuildInputs = [
    astring
    fmt
    tyxml
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "ANSI escape sequence parser";
    longDescription = ''
      This package provides a basic ANSI escape parser. Program output (such as
      build logs) often includes ANSI escape codes to colour and style the output.
      This library interprets some of the common codes and can convert them to
      HTML, producing basic styled output (e.g. highlighting errors in red).
    '';
    homepage = "https://github.com/ocurrent/ansi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otini ];
  };
})
