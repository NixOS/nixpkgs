{ lib, substituteAll, buildPythonPackage, fetchFromGitHub
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "NicklasTegner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1vQmONQFJrjptwVVjw25Wyt59loatjScsdnSax+q/f8=";
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
