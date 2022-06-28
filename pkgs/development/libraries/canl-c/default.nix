{ lib, stdenv, fetchFromGitHub
, perl, libtool, bison, texlive, pkg-config
, c-ares, openssl, libkrb5
}:

stdenv.mkDerivation rec {
  pname = "canl-c";
  version = "3.0.0-1";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = pname;
    rev = "emi-canl-c_R_3_0_0_1";
    sha256 = "sha256-2kivggoM0jCRm+YfaQRBFl4NmyPDmQQAHRg8sezDa7c=";
  };

  postPatch = ''
    patchShebangs ./configure ./src/*.pl
  '';

  nativeBuildInputs = [
    perl
    libtool
    bison
    pkg-config
    (texlive.combine { inherit (texlive) scheme-tetex lastpage multirow; })
  ];

  buildInputs = [ c-ares openssl libkrb5 ];

  configureFlags = [ "--root=/" ];
  setOutputFlags = false;

  outputs = [ "out" "dev" "doc" ];

  meta = with lib; {
    description = "Common Authentication library - bindings for C";
    homepage = "https://github.com/CESNET/canl-c";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ dandellion ];
    platforms = platforms.unix;
  };
}
