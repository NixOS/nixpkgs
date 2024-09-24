{ lib
, pkgs
, fetchFromGitHub
, mongoc
, openssl
, cyrus_sasl
, cmake
, validatePkgConfig
, testers
, darwin
}:

let stdenv = if pkgs.stdenv.hostPlatform.isDarwin then darwin.apple_sdk_11_0.stdenv else pkgs.stdenv; in

stdenv.mkDerivation (finalAttrs: {
  pname = "mongocxx";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-cxx-driver";
    rev = "refs/tags/r${finalAttrs.version}";
    hash = "sha256-nGLE0vyCe3PaNJf3duXdBfAhTdRvdeQ+OCwcaSDxi5Y=";
  };

  postPatch = ''
    substituteInPlace src/bsoncxx/cmake/libbsoncxx.pc.in \
      src/mongocxx/cmake/libmongocxx.pc.in \
      --replace "\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    mongoc
    openssl
    cyrus_sasl
  ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security;

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=20"
    "-DBUILD_VERSION=${finalAttrs.version}"
    "-DENABLE_UNINSTALL=OFF"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Official C++ client library for MongoDB";
    homepage = "http://mongocxx.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ adriandole vcele ];
    pkgConfigModules = [ "libmongocxx" "libbsoncxx" ];
    platforms = platforms.all;
    badPlatforms = [ "x86_64-darwin" ]; # needs sdk >= 10.14
  };
})
