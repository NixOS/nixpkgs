{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  zenoh-c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenoh-cpp";
  version = "1.9.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-cpp";
    tag = finalAttrs.version;
    hash = "sha256-MwQKTxrQqfoASCRk+vBeS9EHvmh6sqrpqygQVrdGkWw=";
  };

  patches = [
    # ref. https://github.com/eclipse-zenoh/zenoh-cpp/pull/790 merged upstream
    (fetchpatch2 {
      name = "fix-cmake-exports-and-pc.patch";
      url = "https://github.com/eclipse-zenoh/zenoh-cpp/commit/a55543277ce93fa3d0871b5b30fb18c04a283db2.patch?full_index=true";
      hash = "sha256-oaCeLTrQ7veWzpTEKGo4pDmNLKmnBIjBkuX71vRtjoo=";
    })
  ];

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
