{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "6.0.0";
  pname = "fmt";

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = version;
    sha256 = "0yfrw6by4h27k3psv9x1q7z2kdbz7pkwxidr494bpa6ppglij6ba";
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
