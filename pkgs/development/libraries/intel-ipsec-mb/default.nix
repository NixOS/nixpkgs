{ lib
, stdenv
, fetchFromGitHub
, nasm
}:

stdenv.mkDerivation rec {
  pname = "intel-ipsec-mb";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-ipsec-mb";
    rev = "v${version}";
    sha256 = "sha256-H6QkThIHRbRZMICKYFGF1zE2zSvGX+WMPr84rpnMHw8=";
  };
  sourceRoot = "source/lib";

  nativeBuildInputs = [ nasm ];

  makeFlags = [ "PREFIX=$(out)" "NOLDCONFIG=y"];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/intel/intel-ipsec-mb";
    license = licenses.bsd3;
    description = "Intel Multi-Buffer Crypto for IPsec Library";
    longDescription = ''
      The library provides software crypto acceleration primarily targeting packet processing
      applications. It can be used for application such as: IPsec, TLS, Wireless (RAN), Cable or
      MPEG DRM.
    '';
    platforms = [ "x86_64-linux" "x86_64-freebsd" ];
    maintainers = with maintainers; [ cariandrum22 ];
  };
}
