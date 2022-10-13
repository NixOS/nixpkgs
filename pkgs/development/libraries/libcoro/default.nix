{ lib, stdenv
, cmake
, fetchFromGitHub
, openssl
, c-ares
, tl-expected
}:

stdenv.mkDerivation rec {
  pname = "libcoro";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "jbaldwin";
    repo = "libcoro";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hSu7ymY5ASyI7s1MRJ2SJPd8ZhaZO0KFKPXHZBnEyXc=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ c-ares openssl.dev tl-expected ];

  meta = with lib; {
    homepage = "https://github.com/jbaldwin/libcoro";
    description = "A C++20 coroutine library";
    license = licenses.asl20;
    maintainers = with maintainers; [ jstranik ];
  };
}
