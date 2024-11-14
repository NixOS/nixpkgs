{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  gz-common,
  gz-msgs,
  tinyxml-2,
  curl,
  jsoncpp,
  libyaml,
  libzip,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-fuel-tools";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-fuel-tools";
    tag = "${
      if lib.versionAtLeast finalAttrs.version "8.0.0" then "gz-fuel-tools" else "ignition-fuel-tools"
    }${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [ cmake ];

  # TODO: This is a *lot* of propagated inputs. Is this **really** necessary?
  propagatedNativeBuildInputs = [ gz-cmake ];
  propagatedBuildInputs = [
    gz-common
    tinyxml-2
    curl
    jsoncpp
    libyaml
    libzip
    gz-msgs
  ];

  meta = {
    homepage = "https://gazebosim.org/libs/fuel_tools";
    description = "Classes and tools for interacting with Gazebo Fuel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
