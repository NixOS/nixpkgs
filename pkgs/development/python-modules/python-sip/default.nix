{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.13.2";
  
  src = fetchurl {
    urls = [
      "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz"
      "http://pkgs.fedoraproject.org/repo/pkgs/sip/${name}.tar.gz/5a12ea8e8a09b879ed2b3817e30fbc84/${name}.tar.gz"
    ];
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
