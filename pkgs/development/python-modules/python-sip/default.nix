{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "sip-4.7.9";
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.7.9.tar.gz;
    md5 = "597d7ff7edb42a18421c806ffd18a136";
  };
  configurePhase = "python ./configure.py -d $out/lib/python2.5/site-packages -b $out/bin -e $out/include";
  buildInputs = [ python ];
}
