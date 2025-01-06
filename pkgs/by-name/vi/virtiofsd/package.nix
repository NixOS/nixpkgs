{ lib, stdenv, rustPlatform, fetchFromGitLab, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.13.0";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    hash = "sha256-IM1xdwiP2NhWpxnyHzwXhsSL4bw2jH0IZLcVhY+Gr50=";
  };

  separateDebugInfo = true;

  cargoHash = "sha256-mD6hZxkqLGdzMfeD9BDZDObCm607mR6LTWhWwDsfRH8=";

  LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
  LIBCAPNG_LINK_TYPE =
    if stdenv.hostPlatform.isStatic then "static" else "dylib";

  buildInputs = [ libcap_ng libseccomp ];

  postConfigure = ''
    sed -i "s|/usr/libexec|$out/bin|g" 50-virtiofsd.json
  '';

  postInstall = ''
    install -Dm644 50-virtiofsd.json "$out/share/qemu/vhost-user/50-virtiofsd.json"
  '';

  meta = {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with lib.maintainers; [ qyliss astro ];
    mainProgram = "virtiofsd";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ asl20 /* and */ bsd3 ];
  };
}
