{ lib, substituteAll, buildPythonPackage, fetchPypi
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Tv0vqKN9AAXdfQRMt/QuqeFB3wNTh1DsWu0XNZukTUc=";
  };

  patches = [
    (substituteAll {
      src = ./static-pandoc-path.patch;
      pandoc = "${lib.getBin pandoc}/bin/pandoc";
      pandocVersion = pandoc.version;
    })
    ./skip-tests.patch
  ];

  checkInputs = [
    texlive.combined.scheme-small
  ];

  meta = with lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/NicklasTegner/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann bennofs ];
  };
}
