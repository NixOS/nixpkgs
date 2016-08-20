{ stdenv, fetchFromGitHub, cmake, doxygen }:

stdenv.mkDerivation {
  name = "uri-2017-07-16";

  src = fetchFromGitHub {
    owner = "cpp-netlib";
    repo = "uri";
    rev = "ac30f19cc7a4745667a8ebd3eac68d5e70b9a4a6";
    sha256 = "0ys295ij071rilwkk3xq1p3sdzgb0gyybvd3f0cahh67kh8hyk6n";
  };

  nativeBuildInputs = [ cmake doxygen ];

  cmakeFlags = {
    BUILD_SHARED_LIBS = true;
    Uri_BUILD_DOCS = true;
    Uri_BUILD_TESTS = false;
  };

  postBuild = "make doc";

  postInstall = ''
    install -vd $out/share/doc
    cp -vR html $out/share/doc
  '';

  meta = {
    description = "C++ URI library";
    homepage = https://cpp-netlib.org;
    license = stdenv.lib.licenses.boost;
    platforms = stdenv.lib.platforms.all;
  };
}
