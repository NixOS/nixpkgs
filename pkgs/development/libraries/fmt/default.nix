{ stdenv, fetchFromGitHub, cmake, enableShared ? true }:

stdenv.mkDerivation rec {
  version = "5.2.1";
  name = "fmt-${version}";
  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "${version}";
    sha256 = "1cd8yq8va457iir1hlf17ksx11fx2hlb8i4jml8gj1875pizm0pk";
  };
  nativeBuildInputs = [ cmake ];
  doCheck = true;
  # preCheckHook ensures the test binaries can find libfmt.so.5
  preCheck = if enableShared
             then "export LD_LIBRARY_PATH=\"$PWD\""
             else "";
  cmakeFlags = [ "-DFMT_TEST=yes"
                 "-DBUILD_SHARED_LIBS=${if enableShared then "ON" else "OFF"}" ];
  meta = with stdenv.lib; {
    homepage = http://fmtlib.net/;
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
