{ lib, stdenvNoCC, buildPackages }:

let
  rpath = lib.makeLibraryPath [
    buildPackages.stdenv.cc.libc
    "$out"
  ];
  bootstrapCrossRust = stdenvNoCC.mkDerivation {
    name = "binary-redox-rust";

    src = buildPackages.fetchzip {
      name = "redox-rust-toolchain.tar.gz";
      url = "https://www.dropbox.com/s/qt7as0j7cwnin8z/redox-rust-toolchain.tar.gz?dl=1";
      sha256 = "1g17qp2q6b88p04yclkw6amm374pqlakrmw9kd86vw8z4g70jkxm";
    };

    dontBuild = true;
    dontPatchELF = true;
    dontStrip = true;
    installPhase = ''
      mkdir $out/
      cp -r * $out/

      find $out/ -executable -type f -exec patchelf \
          --set-interpreter "${buildPackages.stdenv.cc.libc}/lib/ld-linux-x86-64.so.2" \
          --set-rpath "${rpath}" \
          "{}" \;
      find $out/ -name "*.so" -type f -exec patchelf \
          --set-rpath "${rpath}" \
          "{}" \;
    '';

    meta.platforms = with lib; platforms.redox ++ platforms.linux;
  };

  redoxRustPlatform = buildPackages.makeRustPlatform {
    rustc = bootstrapCrossRust;
    cargo = bootstrapCrossRust;
  };

in
redoxRustPlatform.buildRustPackage rec {
  pname = "relibc";
  version = "latest";

  LD_LIBRARY_PATH = "${buildPackages.zlib}/lib";

  src = buildPackages.fetchgit {
    url = "https://gitlab.redox-os.org/redox-os/relibc/";
    rev = "5af8e3ca35ad401014a867ac1a0cc3b08dee682b";
    sha256 = "1j4wsga9psl453031izkl3clkvm31d1wg4y8f3yqqvhml2aliws5";
    fetchSubmodules = true;
  };

  RUSTC_BOOTSTRAP = 1;

  dontInstall = true;
  dontFixup = true;
  doCheck = false;

  postBuild = ''
    mkdir -p $out
    DESTDIR=$out make install
  '';

  # TODO: should be hostPlatform
  TARGET = buildPackages.rust.toRustTargetSpec stdenvNoCC.targetPlatform;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "redox_syscall-0.2.0" = "sha256-nwbJBrhuc01fPbBgd5ShboNu0Nauqp2UjkA+sm9oCeE=";
    };
  };

  # error: Usage of `RUSTC_WORKSPACE_WRAPPER` requires `-Z unstable-options`
  auditable = false;

  meta = with lib; {
    homepage = "https://gitlab.redox-os.org/redox-os/relibc";
    description = "C Library in Rust for Redox and Linux";
    license = licenses.mit;
    maintainers = [ maintainers.aaronjanse ];
    platforms = platforms.redox ++ [ "x86_64-linux" ];
  };
}
