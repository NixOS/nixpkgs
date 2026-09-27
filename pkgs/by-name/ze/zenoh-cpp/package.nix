{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zenoh-c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenoh-cpp";
  version = "1.10.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-cpp";
    tag = finalAttrs.version;
    hash = "sha256-EX3TSm0gAaRS2mj8o90zKsFvSqv2bgjrCnW4b1cC4JM=";
  };

  cmakeFlags = [
    (lib.cmakeBool "ZENOHCXX_ZENOHC" true)
    (lib.cmakeBool "ZENOHCXX_ZENOHPICO" false)
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    zenoh-c
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "C++ API for zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-cpp";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
  };
})
