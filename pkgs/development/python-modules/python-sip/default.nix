{stdenv, fetchurl, lib, python}:

stdenv.mkDerivation {
  name = "sip-4.8.2";
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.8.2.tar.gz;
    sha256 = "1afr2qaibzgf8fq4fmc31jz9hvbwxbg5jvl68ygvkkdvnbg2kfrf";
  };
  configurePhase = "python ./configure.py -d $out/lib/python2.5/site-packages -b $out/bin -e $out/include";
  buildInputs = [ python ];
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
