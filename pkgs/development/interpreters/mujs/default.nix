{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2015-01-22";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "d9ed73fd717ebbefe5595d139a133b762cea4e92";
    sha256 = "0kg69j9ra398mdxzq34k5lv92q18g0zz5vx2wcki3qmag2rzivhr";
  };

  buildInputs = [ clang ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://mujs.com/;
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
