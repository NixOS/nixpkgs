{ stdenv, fetchsvn, eigen }:

stdenv.mkDerivation rec {
  name = "vcg-2016-02-14";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/vcg/code/trunk/vcglib";
    rev = 5688;
    sha256 = "0hkvz2d8prrjdcc7h0xhfd9hq86lmqg17ml045x4bkiciimx0w5s";
  };

  propagatedBuildInputs = [ eigen ];

  installPhase = ''
    mkdir -p $out/include
    cp -r vcg wrap $out/include
    find $out -name \*.h -exec sed -i 's,<eigenlib/,<eigen3/,g' {} \;
  '';

  meta = with stdenv.lib; {
    homepage = http://vcg.isti.cnr.it/vcglib/install.html;
    description = "C++ library for manipulation, processing and displaying with OpenGL of triangle and tetrahedral meshes";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
