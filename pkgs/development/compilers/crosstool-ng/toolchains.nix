{ stdenv
, lib
, crosstool-ng
, crosstool-ng-fetcher
, cacert
, python3
, writeShellScript
}:

let toolchains = import ./configs.nix;
in
(builtins.mapAttrs
  (name: { configFromSample, sourceSha256 }: stdenv.mkDerivation {
    pname = "crosstool-ng-toolchain-${name}";
    version = crosstool-ng.version;
    src = crosstool-ng-fetcher {
      inherit name;
      sha256 = sourceSha256;
      inherit configFromSample;
    };

    unpackPhase = ''
      cp -r $src/.config .
      chmod +w .config
      echo CT_LOCAL_TARBALLS_DIR=$src/tarballs >> .config
      echo CT_PREFIX_DIR=$PWD/prefix >> .config
    '';

    buildPhase = ''
      unset CC CXX
      ct-ng build
    '';

    installPhase = ''
      cp -r prefix $out
      rm -f $out/build.log.gz
    '';

    nativeBuildInputs = [ crosstool-ng python3 ];

    # Fix error: '-Wformat-security' when building gcc
    hardeningDisable = [ "format" ];

    # patchelf complains wrong ELF type
    dontPatchELF = true;

    meta = with lib; {
      homepage = "https://crosstool-ng.github.io/";
      description = "toolchain built by crosstool-ng";
      license = licenses.gpl2;
      maintainers = with maintainers; [ jiegec ];
      platforms = platforms.unix;
    };
  })
  toolchains)
