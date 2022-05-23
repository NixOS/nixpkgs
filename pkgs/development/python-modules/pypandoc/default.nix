{ lib, substituteAll, buildPythonPackage, fetchPypi, isPy27
, pandoc, texlive
}:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.8";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "01nl7dzpf0hchrf4hkdr0a6bvhkrlaahbsh9905qprs407gzz1gr";
  };

  patches = [
    (substituteAll {
      src = ./static-pandoc-path.patch;
      pandoc = "${lib.getBin pandoc}/bin/pandoc";
      pandocVersion = pandoc.version;
    })
    ./skip-tests.patch
  ];

  # Test suite does some checks expecting files missing in the pypi tarball,
  # creating faux versions of them is easier than patching the test out.
  # https://github.com/NicklasTegner/pypandoc/issues/277
  preCheck = ''
    test ! -f release.md || ( echo "Remove preCheck workaround"; exit 1 )
    echo '# making a release' > release.md
  '';
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
