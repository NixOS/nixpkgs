{lib, fetchurl, python, mkPythonDerivation, makeWrapper}:

mkPythonDerivation rec {
  name = "PyXML-0.8.4";
  src = fetchurl {
    url = "mirror://sourceforge/pyxml/${name}.tar.gz";
    sha256 = "04wc8i7cdkibhrldy6j65qp5l75zjxf5lx6qxdxfdf2gb3wndawz";
  };

  buildInputs = [ makeWrapper ];
  buildPhase = "${python.interpreter} ./setup.py build";
  installPhase = ''
    ${python.interpreter} ./setup.py install --prefix="$out" || exit 1

    for i in "$out/bin/"*
    do
      wrapProgram "$i" --prefix PYTHONPATH :  \
       "$out/${python.sitePackages}" ||  \
        exit 2
    done
  '';

  meta = {
    description = "A collection of libraries to process XML with Python";
    homepage = http://pyxml.sourceforge.net/;
  };
}
