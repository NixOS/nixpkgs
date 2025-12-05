{
  lib,
  stdenv,
  fetchFromGitHub,
  premake5,
  doxygen,
  libsodium,
  mbedtls_2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yojimbo";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "mas-bandwidth";
    repo = "yojimbo";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-GMYkWQTwHm7fGRSTIt2phv01CjEcw0l4iPQD4uTQ5yM=";
  };

  nativeBuildInputs = [
    premake5
    doxygen
  ];
  propagatedBuildInputs = [
    libsodium
    mbedtls_2
  ];

  patches = [
    # https://github.com/mas-bandwidth/serialize/pull/6
    ./silence-uninitialized-warning.patch
  ];

  postBuild = ''
    doxygen doxygen.config
  '';

  installPhase = ''
    install -Dm755 -t $out/lib bin/libyojimbo.a
    cp -r -t $out include
    mkdir -p $out/share/doc/yojimbo
    cp -r docs/html $out/share/doc/yojimbo
  '';

  doCheck = true;

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Network library for client/server games with dedicated servers";
    longDescription = ''
      yojimbo is a network library for client/server games with dedicated servers.
      It's designed around the networking requirements of competitive multiplayer games like first person shooters.
      As such it provides a time critical networking layer on top of UDP, with a client/server architecture supporting up to 64 players per-dedicated server instance.
    '';
    homepage = "https://github.com/mas-bandwidth/yojimbo";
    license = licenses.bsd3;
    platforms = platforms.x86_64;
    maintainers = [ ];
  };
})
