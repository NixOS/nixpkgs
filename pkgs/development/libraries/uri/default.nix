{ stdenv, fetchFromGitHub, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "uri-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "cpp-netlib";
    repo = "uri";
    rev = "v${version}";
    sha256 = "148361pixrm94q6v04k13s1msa04bx9yc3djb0lxpa7dlw19vhcd";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=parentheses" ];

  nativeBuildInputs = [ cmake doxygen ];

  cmakeFlags = [
    "-DUri_BUILD_TESTS=OFF" "-DUri_BUILD_DOCS=ON" "-DBUILD_SHARED_LIBS=ON"
  ];

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
