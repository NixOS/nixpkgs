{stdenv, fetchurl, lib, python}:

stdenv.mkDerivation {
  name = "sip-4.9";
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.9.tar.gz;
    sha256 = "00ny3vj34pbykscp7jjk7qsy0ybx3lwzbw0nxq31r2xq51ayzplv";
  };
  configurePhase = "python ./configure.py -d $out/lib/python2.5/site-packages -b $out/bin -e $out/include";
  buildInputs = [ python ];
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
