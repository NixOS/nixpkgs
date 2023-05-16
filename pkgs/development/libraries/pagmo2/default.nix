{ fetchFromGitHub
, lib, stdenv
, cmake
, eigen
, nlopt
, ipopt
, boost
, tbb
 # tests pass but take 30+ minutes
, runTests ? false
}:

stdenv.mkDerivation rec {
  pname = "pagmo2";
<<<<<<< HEAD
  version = "2.19.0";
=======
  version = "2.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
     owner = "esa";
     repo = "pagmo2";
     rev = "v${version}";
<<<<<<< HEAD
     sha256 = "sha256-z5kg2xKZ666EPK844yp+hi4iGisaIPme9xNdzsAEEjw=";
=======
     sha256 = "0rd8scs4hj6qd8ylmn5hafncml2vr4fvcgm3agz3jrvmnc7hadrj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen nlopt boost tbb ] ++ lib.optional (!stdenv.isDarwin) ipopt;

  cmakeFlags = [
    "-DPAGMO_BUILD_TESTS=${if runTests then "ON" else "OFF"}"
    "-DPAGMO_WITH_EIGEN3=yes"
    "-DPAGMO_WITH_NLOPT=yes"
    "-DNLOPT_LIBRARY=${nlopt}/lib/libnlopt${stdenv.hostPlatform.extensions.sharedLibrary}"
  ] ++ lib.optionals stdenv.isLinux [
    "-DPAGMO_WITH_IPOPT=yes"
    "-DCMAKE_CXX_FLAGS='-fuse-ld=gold'"
  ] ++ lib.optionals stdenv.isDarwin [
    # FIXME: fails ipopt test with Invalid_Option on darwin, so disable.
    "-DPAGMO_WITH_IPOPT=no"
    "-DLLVM_USE_LINKER=gold"
  ];

  doCheck = runTests;

  meta = with lib; {
    homepage = "https://esa.github.io/pagmo2/";
    description = "Scientific library for massively parallel optimization";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.costrouc ];
  };
}
