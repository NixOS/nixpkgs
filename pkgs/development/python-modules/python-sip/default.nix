{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.13.2";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz";
    sha256 = "1gzff61bi22g6fkdg9iya4q2qfdkwxs19v4rhhf8x4bm7hszbhsb";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = with stdenv.lib.maintainers; [ urkud sander ];
  };
}
