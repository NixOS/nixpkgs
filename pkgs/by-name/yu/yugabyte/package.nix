{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  bash,
  python3,
  nixosTests,
}:

let
  # YugabyteDB is a very large C++/Java/Go project bundling its own LLVM,
  # PostgreSQL fork and ~70 third-party libraries. Building it from source is
  # impractical in nixpkgs (see also the cockroachdb package), so we consume the
  # upstream release tarball. The binaries ship with $ORIGIN-relative rpaths
  # pointing at the bundled lib/yb-thirdparty directory and only need glibc and
  # libgcc_s from the host, which autoPatchelfHook wires up.
  selectSystem =
    attrs:
    attrs.${stdenvNoCC.hostPlatform.system}
      or (throw "yugabyte: unsupported system ${stdenvNoCC.hostPlatform.system}");

  buildNumber = "122";

  arch = selectSystem {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "el8-aarch64";
  };

  hash = selectSystem {
    x86_64-linux = "sha256-AiM22yy8nYruyJt9RyrEh3p4jJIU+VgTl2PGojw0Z+Q=";
    aarch64-linux = "sha256-Vvc5ruo+Eqk8Dsp5A0E9bC8YHuHkEZN6Lsz9vg64xNI=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yugabyte";
  version = "2025.2.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://software.yugabyte.com/releases/${finalAttrs.version}/yugabyte-${finalAttrs.version}-b${buildNumber}-${arch}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    # Provides libgcc_s; everything else the ELF binaries need is bundled.
    (lib.getLib stdenv.cc.cc)
    # Runtime interpreters for the bundled launchers: yugabyted/yb-ctl/ycqlsh
    # are Python scripts and several helpers (configure, fips_install.sh, ...)
    # are bash scripts. patchShebangs wires these from the runtime closure.
    bash
    python3
  ];

  # The shipped binaries carry debug info and rely on their bundled libraries;
  # stripping them buys little and risks breaking the third-party objects.
  dontStrip = true;

  # autoPatchelf is invoked manually in postFixup so that the FIPS config
  # generation, which needs the patched bundled openssl, can run afterwards.
  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/yugabyte
    cp -a . $out/share/yugabyte

    # The bundled OpenSSL provider modules ship with an upstream build-time rpath
    # that contains patchelf's long padding placeholder, which trips up
    # autoPatchelfHook. Point them at the bundled third-party libraries instead.
    for mod in $out/share/yugabyte/lib/ossl-modules/*.so; do
      patchelf --set-rpath '$ORIGIN/../yb-thirdparty' "$mod"
    done

    # yugabyted runs bin/post_install.sh on every `start` and aborts if it fails.
    # Upstream's script performs the FIPS OpenSSL setup by writing into the
    # install directory, which is a read-only path in the Nix store. We pre-run
    # that setup at build time (see postFixup) and replace the runtime script
    # with a no-op so starting a cluster does not try to mutate the store.
    printf '%s\n' \
      '#!/bin/sh' \
      '# Disabled in nixpkgs: FIPS OpenSSL config is generated at build time.' \
      'exit 0' \
      > $out/share/yugabyte/bin/post_install.sh

    # The launchers resolve the install root via realpath($0)/../.., so symlinks
    # from $out/bin into the unpacked tree keep $ORIGIN and YUGABYTE_DIR correct.
    mkdir -p $out/bin
    for prog in \
      yugabyted \
      yb-master \
      yb-tserver \
      yb-admin \
      yb-ts-cli \
      yb-ctl \
      ysqlsh \
      ycqlsh; do
      ln -s ../share/yugabyte/bin/$prog $out/bin/$prog
    done

    runHook postInstall
  '';

  # Patch the binaries first, then (now that the bundled openssl is runnable)
  # generate the FIPS OpenSSL configuration into the store, replacing the
  # runtime work that the disabled post_install.sh would normally do. $out is
  # still writable during fixup.
  postFixup = ''
    autoPatchelf -- "$out"
    ( cd $out/share/yugabyte && bin/fips_install.sh openssl-config )
  '';

  # No installCheck: yb-master/yb-tserver read /sys/devices/system/cpu/present
  # at startup, which is unavailable in the Nix build sandbox.

  passthru.tests = {
    inherit (nixosTests) yugabyte;
  };

  meta = {
    homepage = "https://www.yugabyte.com";
    description = "High-performance distributed SQL database for global, internet-scale apps";
    longDescription = ''
      YugabyteDB is a high-performance, cloud-native, distributed SQL database
      that aims to support all PostgreSQL features. It is best suited for
      cloud-native OLTP (i.e. real-time, business-critical) applications that
      need absolute data correctness and require at least one of the following:
      scalability, high tolerance to failures or globally-distributed
      deployments.

      This package wraps the official upstream release binaries.
    '';
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "yugabyted";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ layus ];
  };
})
