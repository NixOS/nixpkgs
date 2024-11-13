{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  ruby,
  gz-math,
  gz-utils,
  tinyxml-2,
  tinyxml,
  urdfdom,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdformat";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "sdformat";
    tag = "sdformat${lib.versions.major version}_${version}";
    inherit hash;
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    gz-cmake
    ruby
  ];
  buildInputs = [
    gz-math
    gz-utils
    urdfdom
  ];
  propagatedBuildInputs = [
    gz-math
    (if lib.versionAtLeast version "10.0.0" then tinyxml-2 else tinyxml)
  ];

  meta = {
    homepage = "http://sdformat.org/";
    description = "Simulation Description Format (SDF) parser and description files";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
