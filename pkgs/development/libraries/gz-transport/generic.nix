{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gz-cmake,
  gz-math,
  gz-msgs,
  gz-utils,
  protobuf,
  libuuid,
  sqlite,
  libsodium,
  cppzmq,
  zeromq,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-transport";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-transport";
    tag = "${
      if lib.versionAtLeast finalAttrs.version "12.0.0" then "gz-transport" else "ignition-transport"
    }${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gz-math
    sqlite
    libsodium
    gz-utils
  ];

  # TODO: More propagated inputs. How many of these are necessary?
  propagatedNativeBuildInputs = [ gz-cmake ];
  propagatedBuildInputs = [
    protobuf
    cppzmq
    zeromq
    libuuid
    gz-msgs
  ];

  meta = {
    homepage = "https://gazebosim.org/libs/transport/";
    description = "Provides fast and efficient asyncronous message passing, services, and data logging.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
