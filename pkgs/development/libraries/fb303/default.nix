{ stdenv
, lib
, fetchFromGitHub
, cmake
, fbthrift
, fizz
, folly
, glog
, libsodium
, mvfst
, python3
, wangle
, zlib
}:

stdenv.mkDerivation rec {
  pname = "fb303";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fb303";
    rev = "v${version}";
    sha256 = "sha256-Jtztb8CTqvRdRjUa3jaouP5PFAwoM4rKLIfgvOyXUIg=";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DPYTHON_EXTENSIONS=OFF"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  buildInputs = [
    fbthrift
    fizz
    folly
    folly.boost
    folly.fmt
    glog
    libsodium
    mvfst
    python3
    wangle
    zlib
  ];

  meta = with lib; {
    description = "Base Thrift service and a common set of functionality for querying stats, options, and other information from a service";
    homepage = "https://github.com/facebook/fb303";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
