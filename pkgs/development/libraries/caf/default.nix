{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
}:

stdenv.mkDerivation rec {
  pname = "actor-framework";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = version;
    hash = "sha256-AW8AXX9t9vYv8tZvFJvrghmz6tZdfbX4hVc2QoBAvhQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cmakeFlags = [
    "-DCAF_ENABLE_EXAMPLES:BOOL=OFF"
  ];

  doCheck = true;

  checkTarget = "test";

  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/libcaf_core:$PWD/libcaf_io
    export DYLD_LIBRARY_PATH=$PWD/libcaf_core:$PWD/libcaf_io
  '';

  meta = with lib; {
    description = "Implementation of the actor model";
    homepage = "http://actor-framework.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    changelog = "https://github.com/actor-framework/actor-framework/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ bobakker tobim ];
  };
}
