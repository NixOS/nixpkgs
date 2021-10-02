{ lib, substituteAll, buildPythonPackage, fetchFromGitHub
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "NicklasTegner";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rssjig3nwdi4qvsjq7v7k8jyv6l9szfl5dp1a8s54c4j4dw37nh";
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
