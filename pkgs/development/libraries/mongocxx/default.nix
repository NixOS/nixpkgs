{ lib
, stdenv
, fetchFromGitHub
, mongoc
, cmake
, validatePkgConfig
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongocxx";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-cxx-driver";
    rev = "refs/tags/r${finalAttrs.version}";
    hash = "sha256-7pMVBWMIGV6k04/0rKULwNcl0NMO4hqMnOzWv+0/DrA=";
  };

  postPatch = ''
    substituteInPlace src/bsoncxx/config/CMakeLists.txt \
      src/mongocxx/config/CMakeLists.txt \
      --replace "\\\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    mongoc
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=20"
    "-DBUILD_VERSION=${finalAttrs.version}"
    "-DENABLE_UNINSTALL=OFF"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "The official C++ client library for MongoDB";
    homepage = "http://mongocxx.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ adriandole ];
    pkgConfigModules = [ "libmongocxx" "libbsoncxx" ];
    platforms = platforms.all;
    badPlatforms = [ "x86_64-darwin" ]; # needs sdk >= 10.14
  };
})
