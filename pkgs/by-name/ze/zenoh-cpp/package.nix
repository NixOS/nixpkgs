{
  lib,
  stdenv,
  fetchFromGitHub,
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

  cmakeFlags = [
    "-DZENOHCXX_ZENOHC=ON"
    "-DZENOHCXX_ZENOHPICO=OFF"
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    zenoh-c
  ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/zenohcxx.pc \
      --replace-fail "\''${prefix}/" ""
  '';

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
