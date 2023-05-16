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
<<<<<<< HEAD
  version = "2023.06.12.00";
=======
  version = "2023.04.24.00";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fb303";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-nUOPYb5/tLyHjaZDvKuq0vdu4L7XOmO8R9nNLGAzeLI=";
=======
    sha256 = "sha256-dhqHv+A4uak1FxKNqIsYlQl2WiP5+Y9I83pumpFbJDA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
