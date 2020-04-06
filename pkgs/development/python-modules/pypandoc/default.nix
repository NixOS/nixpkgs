{ stdenv, buildPythonPackage, fetchFromGitHub
, pandoc, haskellPackages, texlive }:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "unstable-2018-06-18";

  src = fetchFromGitHub {
    owner = "bebraw";
    repo = pname;
    rev = "87912f0f17e0a71c1160008df708c876d32e5819";
    sha256 = "0l6knkxxhmni4lx8hyvbb71svnhza08ivyklqlk5fw637gznc0hx";
  };

  postPatch = ''
    # set pandoc path statically
    sed -i '/^__pandoc_path = None$/c__pandoc_path = "${pandoc}/bin/pandoc"' pypandoc/__init__.py

    # Fix tests: requires network access
    substituteInPlace tests.py --replace "pypandoc.convert(url, 'html')" "'GPL2 license'"
  '';

  preCheck = ''
    export PATH="${haskellPackages.pandoc-citeproc}/bin:${texlive.combined.scheme-small}/bin:$PATH"
  '';

  meta = with stdenv.lib; {
    description = "Thin wrapper for pandoc";
    homepage = https://github.com/bebraw/pypandoc;
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann bennofs ];
  };
}
