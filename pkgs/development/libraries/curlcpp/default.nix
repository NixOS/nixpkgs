{ lib, stdenv, fetchFromGitHub, cmake, curl }:

stdenv.mkDerivation rec {
  pname = "curlcpp";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "JosephP91";
    repo = "curlcpp";
    rev = version;
    sha256 = "1zx76jcddqk4zkcdb6p7rsmkjbbjm2cj6drj0c8hdd61ms1d0f3n";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ curl ];

  meta = with lib; {
    homepage = "https://josephp91.github.io/curlcpp/";
    description = "Object oriented C++ wrapper for CURL";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ rszibele ];
  };
}
