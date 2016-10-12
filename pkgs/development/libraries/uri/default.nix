{ stdenv, fetchFromGitHub, cmake, doxygen }:

stdenv.mkDerivation {
  name = "uri-2016-09-04";

  src = fetchFromGitHub {
    owner = "cpp-netlib";
    repo = "uri";
    rev = "8b1eec80621ea7be1db3b28f1621e531cc72855c";
    sha256 = "0f77y79b11pp31y0qpydki2nnxd6gpycp24fmrapi70fsni2ah0d";
  };

  buildInputs = [ cmake doxygen ];

  cmakeFlags = [ "-DUri_BUILD_TESTS=OFF" "-DBUILD_SHARED_LIBS=ON" ];

  postBuild = ''
    make doc
  '';

  # https://github.com/cpp-netlib/uri/issues/90
  postInstall = ''
    mv $out/include $out/include2
    mv $out/include2/include $out/
    rmdir $out/include2
    mkdir -p $out/share/doc
    mv html $out/share/doc/uri
  '';

  meta = {
    description = "C++ URI library";
    homepage = http://cpp-netlib.org;
    license = stdenv.lib.licenses.boost;
    platforms = stdenv.lib.platforms.all;
  };
}
