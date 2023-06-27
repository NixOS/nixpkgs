{ stdenv
, lib
, fetchFromGitHub
, cmake
, glog
, folly
, fmt_8
, boost
, fbthrift
, zlib
, fizz
, libsodium
, wangle
, python3
}:

stdenv.mkDerivation rec {
  pname = "fb303";
  version = "2023.06.12.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fb303";
    rev = "v${version}";
    sha256 = "sha256-nUOPYb5/tLyHjaZDvKuq0vdu4L7XOmO8R9nNLGAzeLI=";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DPYTHON_EXTENSIONS=OFF"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  buildInputs = [
    glog
    folly
    fmt_8
    boost
    fbthrift
    zlib
    fizz
    libsodium
    wangle
    python3
  ];

  meta = with lib; {
    description = "a base Thrift service and a common set of functionality for querying stats, options, and other information from a service";
    homepage = "https://github.com/facebook/fb303";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
