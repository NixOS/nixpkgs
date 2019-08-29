{ stdenv, fetchFromGitHub, cmake, zeromq }:

stdenv.mkDerivation rec {
  name = "cppzmq-${version}";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "v${version}";
    sha256 = "15dgkv51csfkafplf0n0vqbjdr4pxqxq44dln0dcizhsn1p0a57q";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zeromq ];

  cmakeFlags = [
    # Tests try to download googletest at compile time; there is no option
    # to use a system one and no simple way to download it beforehand.
    "-DCPPZMQ_BUILD_TESTS=OFF"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zeromq/cppzmq;
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
