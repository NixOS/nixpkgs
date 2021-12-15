{ lib, substituteAll, buildPythonPackage, fetchFromGitHub
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "NicklasTegner";
    repo = pname;
    rev = "v${version}";
    sha256 = "00r88qcvc9jpi8jvd6rpizz9gm33aq8hc3mf8lrarrjiq2fsxmk9";
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
