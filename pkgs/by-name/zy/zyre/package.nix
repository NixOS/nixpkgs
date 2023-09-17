{ lib
, stdenv
, fetchFromGitHub
, cmake
, czmq
}:

stdenv.mkDerivation rec {
  pname = "zyre";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "zyre";
    rev = "v${version}";
    hash = "sha256-sIsqOgw0Xo6nCzDT81YZNz4FPYhSa/5W2UPz2CnAec4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    czmq
  ];

  meta = with lib; {
    description = "An open-source framework for proximity-based peer-to-peer applications";
    homepage = "https://github.com/zeromq/zyre";
    changelog = "https://github.com/zeromq/zyre/blob/${src.rev}/NEWS";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rs0vere ];
  };
}
