{ lib, substituteAll, buildPythonPackage, fetchFromGitHub
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "bebraw";
    repo = pname;
    rev = version;
    sha256 = "1lpslfns6zxx7b0xr13bzg921lwrj5am8za0b2dviywk6iiib0ld";
  };

  patches = [
    (substituteAll {
      src = ./static-pandoc-path.patch;
      pandoc = "${lib.getBin pandoc}/bin/pandoc";
    })
    ./skip-tests.patch
    ./new-pandoc-headings.patch
  ];

  checkInputs = [
    texlive.combined.scheme-small
  ];

  meta = with lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/bebraw/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann bennofs ];
  };
}
