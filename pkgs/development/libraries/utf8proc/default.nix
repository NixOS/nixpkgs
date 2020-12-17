{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zqc6airkzkssbjxanx5v8blfk90180gc9id0dx8ncs54f1ib8w7";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUTF8PROC_ENABLE_TESTING=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ];

  # the pkg-config file is not created in the cmake installation
  # process, so we use the Makefile and install it manually
  # see https://github.com/JuliaStrings/utf8proc/issues/198
  preConfigure = "make libutf8proc.pc prefix=$out";
  postInstall = "install -Dm644 ../libutf8proc.pc -t $out/lib/pkgconfig/";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx ];
  };
}
