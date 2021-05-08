{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "actor-framework";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = version;
    sha256 = "sha256-tRR+YFI/Ikf4rov4dzt59nDqaooALNspKEQehHP6sKU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

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
    description = "An open source implementation of the actor model in C++";
    homepage = "http://actor-framework.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bobakker tobim ];
  };
}
