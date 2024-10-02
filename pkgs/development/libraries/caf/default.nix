{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "actor-framework";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = version;
    hash = "sha256-ANtqGFctgOAynDiZS9tmWRASVpB2RqRTG7JSXZIDmP8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DCAF_ENABLE_EXAMPLES:BOOL=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-faligned-allocation";

  doCheck = !stdenv.hostPlatform.isDarwin;
  checkTarget = "test";

  meta = with lib; {
    description = "Open source implementation of the actor model in C++";
    homepage = "http://actor-framework.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    changelog = "https://github.com/actor-framework/actor-framework/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ bobakker tobim ];
  };
}
