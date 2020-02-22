{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "6.1.1";
  pname = "fmt";

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = version;
    sha256 = "0arii4hs33lqlbfwilnxiq8mqcvdwz66b24qa7fdjiga02j8kl2n";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFMT_TEST=TRUE"
    "-DBUILD_SHARED_LIBS=TRUE"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  # preCheckHook ensures the test binaries can find libfmt.so
  preCheck = ''
    export LD_LIBRARY_PATH="$PWD"
  '';

  meta = with stdenv.lib; {
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    homepage = http://fmtlib.net/;
    downloadPage = https://github.com/fmtlib/fmt/;
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
