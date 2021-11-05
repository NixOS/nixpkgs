{ lib
, stdenv
, fetchFromGitHub
, wafHook
, python3
, pkg-config
, openssl
, boost
}:

stdenv.mkDerivation rec {
  pname = "asdcplib-carl";
  version = "unstable-2021-10-28";

  src = fetchFromGitHub {
    owner = "cth103";
    repo = "asdcplib";
    rev = "8f23c6c904d17e468bf94397fee28e1242cb1651";
    sha256 = "006ja8iclb4f3qx011p9qkjxza2ysxy060501rdz4q7a3fl3lvrz";
  };

  postPatch = ''
    echo "0.1.6-${version}" > VERSION
  '';

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    openssl
  ];

  buildInputs = [
    boost
  ];

  nativeBuildInputs = [
    wafHook
    python3
    pkg-config
  ];

  meta = with lib; {
    description = "Open-source implementation of SMPTE and MXF Interop format";
    homepage = "https://carlh.net/asdcplib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lukegb ];
  };
}
