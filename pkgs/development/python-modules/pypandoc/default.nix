{ lib, substituteAll, buildPythonPackage, fetchFromGitHub
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "NicklasTegner";
    repo = pname;
    rev = version;
    sha256 = "163wkcm06klr68dadr9mb8gblj0ls26w097bjrg4f5j0533ysdpp";
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
