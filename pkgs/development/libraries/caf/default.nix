{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "actor-framework";
  version = "0.18.7";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = version;
    hash = "sha256-y1RE6AnyOrUN/z4md/xjlVwlIcL97ZEcKEOf8ZsCf+U=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DCAF_ENABLE_EXAMPLES:BOOL=OFF"
  ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "An open source implementation of the actor model in C++";
    homepage = "http://actor-framework.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    changelog = "https://github.com/actor-framework/actor-framework/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ bobakker tobim ];
  };
}
