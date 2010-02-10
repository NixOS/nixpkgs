{stdenv, fetchurl, lib, python}:

stdenv.mkDerivation {
  name = "sip-4.10";
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.10.tar.gz;
    sha256 = "15nnwn0x92iz5vh5d16dlqvxl56i8y4n4va53gc3f7z4d557d2nh";
  };
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  buildInputs = [ python ];
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
