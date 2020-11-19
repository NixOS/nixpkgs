{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.12.2";

  src = fetchFromGitHub {
    sha256 = "1iz8w0q4m7dqshjqfbwxwrasabs4j8jlil4w3kxdr3v9ldkl4v3d";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost curl ruby ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
