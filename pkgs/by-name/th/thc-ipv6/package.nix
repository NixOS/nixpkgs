{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
    hash = "sha256-vX4bSgDlP8/PyxBM9FqXvZ1T7e8k/XKLFga3H9SMfB4=";
  };

  patches = [
    # Fix gcc-15 build failure:
    #   https://github.com/vanhauser-thc/thc-ipv6/pull/53
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://github.com/vanhauser-thc/thc-ipv6/commit/c9617d5638196bd88336225a6abdfd45c3df0bcf.patch";
      hash = "sha256-4+LmRsDInzzNFHvj8WK+r1fKeoLggQW7yrahC1d6WCs=";
    })
  ];

  buildInputs = [
    libpcap
    openssl
    libnetfilter_queue
    libnfnetlink
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "IPv6 attack toolkit";
    homepage = "https://github.com/vanhauser-thc/thc-ipv6";
    maintainers = with lib.maintainers; [ ajs124 ];
    platforms = lib.platforms.linux;
    license = lib.licenses.agpl3Only;
  };
})
