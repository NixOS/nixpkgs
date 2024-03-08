{ lib
, stdenv
, fetchurl
, darwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ode";
  version = "0.16.4";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/ode/downloads/ode-${finalAttrs.version}.tar.gz";
    hash = "sha256-cQN7goHGyGsKVXKfkNXbaXq+TL7B2BGBV+ANSOwlNGc=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.GLUT
  ];

  env.CXXFLAGS = lib.optionalString stdenv.cc.isClang (toString [
    "-std=c++14"
    "-Wno-error=c++11-narrowing"
  ]);

  meta = with lib; {
    description = "Open Dynamics Engine";
    homepage = "https://www.ode.org";
    license = with licenses; [ bsd3 lgpl21Only lgpl3Only zlib ];
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
})
