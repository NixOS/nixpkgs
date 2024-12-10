{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  json_c,
  libpcap,
  libtool,
  pkg-config,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ndpi";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-V3hRDQ141pbR5jJK2QlP7BF2CEbuzqIvo+iTx3EGhRY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    json_c
    libpcap
  ];

  meta = with lib; {
    description = "A library for deep-packet inspection";
    longDescription = ''
      nDPI is a library for deep-packet inspection based on OpenDPI.
    '';
    homepage = "https://www.ntop.org/products/deep-packet-inspection/ndpi/";
    changelog = "https://github.com/ntop/nDPI/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with licenses; [
      lgpl3Plus
      bsd3
    ];
    maintainers = with maintainers; [ takikawa ];
    mainProgram = "ndpiReader";
    platforms = with platforms; unix;
  };
})
