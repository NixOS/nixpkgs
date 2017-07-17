{ stdenv, buildPythonPackage, fetchPypi
, pip, pandoc, glibcLocales, haskellPackages, texlive }:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.3.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0628f2kn4gqimnhpf251fgzl723hwgyl3idy69dkzyjvi45s5zm6";
  };

  # Fix tests: first requires network access, second is a bug (reported upstream)
  preConfigure = ''
    substituteInPlace tests.py --replace "pypandoc.convert(url, 'html')" "'GPL2 license'"
    substituteInPlace tests.py --replace "pypandoc.convert_file(file_name, lua_file_name)" "'<h1 id=\"title\">title</h1>'"
  '';

  LC_ALL="en_US.UTF-8";

  propagatedBuildInputs = [ pip ];

  buildInputs = [ pandoc texlive.combined.scheme-small haskellPackages.pandoc-citeproc glibcLocales ];

  meta = with stdenv.lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/bebraw/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r ];
  };
}
