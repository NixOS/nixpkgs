{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, libpng, libjpeg
, guiSupport ? false, libX11

  # see http://dlib.net/compile.html
, avxSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "dlib";
  version = "19.21";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "00jwklnl21l3hlvb0bjc6rl3hgi88vxb41dsn4m0kh436c9v0rl3";
  };

  postPatch = ''
    rm -rf dlib/external
  '';

  cmakeFlags = [ "-DUSE_AVX_INSTRUCTIONS=${if avxSupport then "yes" else "no"}" ];

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libpng libjpeg ] ++ lib.optional guiSupport libX11;

  meta = with stdenv.lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = http://www.dlib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ma27 ];
    platforms = platforms.linux;
  };
}
