{stdenv, fetchurl, cmake}:

let
  version = "3.3.4";
in
stdenv.mkDerivation {
  name = "eigen-${version}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "1q85bgd6hnsgn0kq73wa4jwh4qdwklfg73pgqrz4zmxvzbqyi1j2";
  };
  
  nativeBuildInputs = [ cmake ];

  postInstall = ''
    sed -e '/Cflags:/s@''${prefix}/@@' -i "$out"/share/pkgconfig/eigen3.pc
  '';
   
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ sander raskin ];
    inherit version;
  };
}
