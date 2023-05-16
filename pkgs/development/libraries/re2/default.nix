{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, chromium
, grpc
, haskellPackages
, mercurial
, python3Packages
<<<<<<< HEAD
, abseil-cpp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "re2";
<<<<<<< HEAD
  version = "2023-08-01";
=======
  version = "2023-03-01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-RexwqNR/Izf2Rzu1cvMw+le6C4EmL4CeWCOc+vXUBZQ=";
=======
    hash = "sha256-T+P7qT8x5dXkLZAL8VjvqPD345sa6ALX1f5rflE0dwc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ninja ];

<<<<<<< HEAD
  propagatedBuildInputs = [ abseil-cpp ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace re2Config.cmake.in \
      --replace "\''${PACKAGE_PREFIX_DIR}/" ""
  '';

  # Needed for case-insensitive filesystems (i.e. MacOS) because a file named
  # BUILD already exists.
  cmakeBuildDir = "build_dir";

  cmakeFlags = lib.optional (!stdenv.hostPlatform.isStatic) "-DBUILD_SHARED_LIBS:BOOL=ON";

  # This installs a pkg-config definition.
  postInstall = ''
    pushd "$src"
    make common-install prefix="$dev" SED_INPLACE="sed -i"
    popd
  '';

  doCheck = true;

  passthru.tests = {
    inherit
      chromium
      grpc
      mercurial;
    inherit (python3Packages)
      fb-re2
      google-re2;
    haskell-re2 = haskellPackages.re2;
  };

  meta = with lib; {
    description = "A regular expression library";
    longDescription = ''
      RE2 is a fast, safe, thread-friendly alternative to backtracking regular
      expression engines like those used in PCRE, Perl, and Python. It is a C++
      library.
    '';
    license = licenses.bsd3;
    homepage = "https://github.com/google/re2";
<<<<<<< HEAD
    maintainers = with maintainers; [ azahi networkexception ];
=======
    maintainers = with maintainers; [ azahi ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}
