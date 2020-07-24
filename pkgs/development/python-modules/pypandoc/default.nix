{ stdenv, buildPythonPackage, fetchFromGitHub
, pandoc, haskellPackages, texlive }:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "bebraw";
    repo = pname;
    rev = version;
    sha256 = "1lpslfns6zxx7b0xr13bzg921lwrj5am8za0b2dviywk6iiib0ld";
  };

  postPatch = ''
    # set pandoc path statically
    sed -i '/^__pandoc_path = None$/c__pandoc_path = "${pandoc}/bin/pandoc"' pypandoc/__init__.py

    # Skip test that requires network access
    sed -i '/test_basic_conversion_from_http_url/i\\    @unittest.skip\("no network access during checkPhase"\)' tests.py
  '';

  preCheck = ''
    export PATH="${haskellPackages.pandoc-citeproc}/bin:${texlive.combined.scheme-small}/bin:$PATH"
  '';

  meta = with stdenv.lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/bebraw/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann bennofs ];
  };
}
