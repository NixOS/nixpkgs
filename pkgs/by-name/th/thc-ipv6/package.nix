{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  openssl,
  libnetfilter_queue,
  libnfnetlink,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "thc-ipv6";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "vanhauser-thc";
    repo = "thc-ipv6";
    rev = "v${finalAttrs.version}";
    sha256 = "07kwika1zdq62s5p5z94xznm77dxjxdg8k0hrg7wygz50151nzmx";
  };

  buildInputs = [
    libpcap
    openssl
    libnetfilter_queue
    libnfnetlink
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "IPv6 attack toolkit";
    homepage = "https://github.com/vanhauser-thc/thc-ipv6";
    maintainers = with lib.maintainers; [ ajs124 ];
    platforms = lib.platforms.linux;
    license = lib.licenses.agpl3Only;
  };
})
