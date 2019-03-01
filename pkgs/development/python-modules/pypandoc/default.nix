{ stdenv, buildPythonPackage, fetchFromGitHub
, pandoc, glibcLocales, haskellPackages, texlive }:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "2019-03-01";

  src = fetchFromGitHub {
    owner = "bebraw";
    repo = "pypandoc";
    rev = "87912f0f17e0a71c1160008df708c876d32e5819";
    sha256 = "0l6knkxxhmni4lx8hyvbb71svnhza08ivyklqlk5fw637gznc0hx";
  };

  # Fix tests: requires network access
  preConfigure = ''
    substituteInPlace tests.py --replace "pypandoc.convert(url, 'html')" "'GPL2 license'"
  '';

  propagatedNativeBuildInputs = [
    pandoc
    texlive.combined.scheme-small
    haskellPackages.pandoc-citeproc
    glibcLocales
  ];

  meta = with stdenv.lib; {
    description = "Thin wrapper for pandoc";
    homepage = https://github.com/bebraw/pypandoc;
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs twey ];
  };
}
