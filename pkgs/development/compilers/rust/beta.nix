{ stdenv, callPackage, rustPlatform, cacert, gdb,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = stdenv.lib.overrideDerivation (callPackage ./rustc.nix {
    shortVersion = "beta-2017-01-07";
    forceBundledLLVM = true; # TODO: figure out why linking fails without this
    configureFlags = [ "--release-channel=beta" ];
    srcRev = "a035041ba450ce3061d78a2bdb9c446eb5321d0d";
    srcSha = "12xsm0yp1y39fvf9j218gxv73j8hhahc53jyv3q58kiriyqvfc1s";
    patches = [
     ./patches/disable-lockfile-check-nightly.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  }) (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ gdb rustPlatform.rust.cargo ];
    postUnpack = ''
      export CARGO_HOME="$(realpath deps)"
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    '';
    postPatch = ''
      ${oldAttrs.postPatch}

      # Remove failing debuginfo tests because of old gdb version: https://github.com/rust-lang/rust/issues/38948#issuecomment-271443596
      rm -vr src/test/debuginfo/borrowed-enum.rs || true
      rm -vr src/test/debuginfo/generic-struct-style-enum.rs || true
      rm -vr src/test/debuginfo/generic-tuple-style-enum.rs || true
      rm -vr src/test/debuginfo/packed-struct.rs || true
      rm -vr src/test/debuginfo/recursive-struct.rs || true
      rm -vr src/test/debuginfo/struct-in-enum.rs || true
      rm -vr src/test/debuginfo/struct-style-enum.rs || true
      rm -vr src/test/debuginfo/tuple-style-enum.rs || true
      rm -vr src/test/debuginfo/union-smoke.rs || true
      rm -vr src/test/debuginfo/unique-enum.rs || true

      # make external cargo work until https://github.com/rust-lang/rust/issues/38950 is fixed
      sed -i "s#    def cargo(self):#    def cargo(self):\n        return \"${rustPlatform.rust.cargo}/bin/cargo\"#g" src/bootstrap/bootstrap.py
      substituteInPlace \
        src/bootstrap/config.rs \
        --replace \
        'self.cargo = Some(push_exe_path(path, &["bin", "cargo"]));' \
        ''$'self.cargo = Some(\n                        "${rustPlatform.rust.cargo}\\\n                        /bin/cargo".into());'
    '';
  });

  cargo = callPackage ./cargo.nix rec {
    version = "beta-2017-01-10";
    srcRev = "6dd4ff0f5b59fff524762c4a7b65882adda713c0";
    srcSha = "1x6d42qq2zhr1iaw0m0nslhv6c1w6x6schmd96max0p9xb47l9zj";
    depsSha256 = "1sywnhzgambmqsjs2xlnzracfv7vjljha55hgf8wca2marafr5dp";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
