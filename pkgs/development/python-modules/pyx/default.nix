{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation rec {
  name = "PyX-0.10";
  src = fetchurl {
    url = "mirror://sourceforge/pyx/${name}.tar.gz";
    sha256 = "dfaa4a7790661d67d95f80b22044fdd8a9922483631950296ff1d7a9f85c8bba";
  };

  patchPhase = ''
    substituteInPlace ./setup.py --replace '"/etc"' '"etc"'
  '';

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
    description = ''Python graphics package'';
    longDescription = ''
      PyX is a Python package for the creation of PostScript and PDF
      files. It combines an abstraction of the PostScript drawing
      model with a TeX/LaTeX interface. Complex tasks like 2d and 3d
      plots in publication-ready quality are built out of these
      primitives.
    '';
    license = "GPLv2";
    homepage = http://pyx.sourceforge.net/;
  };
}
