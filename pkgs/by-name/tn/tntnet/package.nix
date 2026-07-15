{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  cxxtools,
  zlib,
  openssl,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tntnet";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "maekitalo";
    repo = "tntnet";
    rev = "V${finalAttrs.version}";
    hash = "sha256-ujVPOreCGCFlYHa19yCIiZ0ed+p0jnS14DHDwKYvtc0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/maekitalo/tntnet/commit/69adfc8ee351a0e82990c1ffa7af6dab726e1e49.patch";
      hash = "sha256-4UdUXKQiIa9CPlGg8XmfKQ8NTWb2A3AiuPthzEthlf8=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    cxxtools
    zlib
    openssl
    zip
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.tntnet.org/tntnet.html";
    description = "Web server which allows users to develop web applications using C++";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.juliendehos ];
  };
})
