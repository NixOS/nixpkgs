{ lib, stdenv, fetchFromGitHub, cmake, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "llhttp";
  version = "9.1.2";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    rev = "release/v${finalAttrs.version}";
    hash = "sha256-kW6u9ETZJcJBh150chfE3SEwFpT7evZ0cqz8caM7fbQ=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_STATIC_LIBS=ON"
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org/";
    changelog = "https://github.com/nodejs/llhttp/releases/tag/release/v${finalAttrs.version}";
    license = licenses.mit;
    pkgConfigModules = [ "libllhttp" ];
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
})
