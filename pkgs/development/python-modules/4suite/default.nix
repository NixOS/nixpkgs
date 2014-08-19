{stdenv, fetchurl, python}:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "4suite-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/foursuite/4Suite-XML-${version}.tar.bz2";
    sha256 = "0g5cyqxhhiqnvqk457k8sb97r18pwgx6gff18q5296xd3zf4cias";
  };
  buildInputs = [python];
  buildPhase = "true";
  installPhase = "python ./setup.py install --prefix=$out";

  # None of the tools installed to bin/ work. They all throw an exception
  # similar to this:
  #   ImportError: No module named Ft.Xml.XPath._4xpath
  meta.broken = true;
}
