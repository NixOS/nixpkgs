{ stdenv
, lib
, fetchFromGitHub
, cmake
, gtest
, withDocs ? true
, doxygen
, graphviz-nox
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastcdr";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-CDR";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZJQnm3JN56y2v/XIShfZxkEEu1AKMJxt8wpRqSn9HWk=";
  };

  patches = [
    ./0001-Do-not-require-wget-and-unzip.patch
  ];

  cmakeFlags = lib.optional (stdenv.hostPlatform.isStatic) "-DBUILD_SHARED_LIBS=OFF"
  # fastcdr doesn't respect BUILD_TESTING
  ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "-DEPROSIMA_BUILD_TESTS=ON"
  ++ lib.optional withDocs "-DBUILD_DOCUMENTATION=ON";

  outputs = [ "out" ] ++ lib.optional withDocs "doc";

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals withDocs [
    doxygen
    graphviz-nox
  ];

  doCheck = true;

  checkInputs = [ gtest ];

  meta = with lib; {
    homepage = "https://github.com/eProsima/Fast-CDR";
    description = "Serialization library for OMG's Common Data Representation (CDR)";
    longDescription = ''
      A C++ library that provides two serialization mechanisms. One is the
      standard CDR serialization mechanism, while the other is a faster
      implementation that modifies the standard.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ panicgh ];
    platforms = platforms.unix;
  };
})
