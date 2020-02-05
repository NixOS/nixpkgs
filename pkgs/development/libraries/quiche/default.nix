{ lib, fetchFromGitHub, rustPlatform, pkgconfig, cmake, perl, go }:

rustPlatform.buildRustPackage rec {
  pname = "quiche";
  version = "0.4.0";

  cargoPatches = [
    ./cargo.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    perl
    cmake
    go
  ];

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = version;
    sha256 = "sha256-nEln0MJwq9eMgBReQGDDSMCE4oznLYuuCv3zkl9Rqkc=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-QtCWf3C65xZw/g+Ap/TC92VGwT3lIrLBx+FKkOVWX6E=";

  preBuild = ''
    export HOME=/tmp
  '';

  meta = with lib; {
    description = "Savoury implementation of the QUIC transport protocol and HTTP/3";
    homepage    = "https://docs.quic.tech/quiche/";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ ajs124 ];
  };
}
