{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, help2man, curl }:

stdenv.mkDerivation rec {
  pname = "libykclient";
  version = "unstable-2019-03-18";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubico-c-client";
    rev = "ad9eda6aac4c3f81784607c30b971f4a050b5c2e";
    sha256 = "01b19jgv2lypih6lhw9yjjsfl8q1ahl955vhr2ai8ccshh0050yj";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig help2man ];
  buildInputs = [ curl ];

  meta = with stdenv.lib; {
    description = "Yubikey C client library";
    homepage = https://developers.yubico.com/yubico-c-client;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
