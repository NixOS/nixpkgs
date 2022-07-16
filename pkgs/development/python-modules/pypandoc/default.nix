{ lib, substituteAll, buildPythonPackage, fetchPypi
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jBtlHTOOhEGEO5kYNfWdVhqEc8/mPwEm0zD9s8tRiAk=";
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
