{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation rec {
  name = "PyXML-0.8.4";
  src = fetchurl {
    url = "mirror://sourceforge/pyxml/${name}.tar.gz";
    sha256 = "04wc8i7cdkibhrldy6j65qp5l75zjxf5lx6qxdxfdf2gb3wndawz";
  };

  buildInputs = [python makeWrapper];
  buildPhase = "python ./setup.py build";
  installPhase = ''
    python ./setup.py install --prefix="$out" || exit 1

    for i in "$out/bin/"*
    do
      # FIXME: We're assuming Python 2.4.
      wrapProgram "$i" --prefix PYTHONPATH :  \
       "$out/lib/python2.4/site-packages" ||  \
        exit 2
    done
  '';

  meta = {
    description = "A collection of libraries to process XML with Python";
    homepage = http://pyxml.sourceforge.net/;
  };
}
