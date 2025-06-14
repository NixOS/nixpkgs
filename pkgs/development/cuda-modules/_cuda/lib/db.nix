{ _cuda, lib }:
let
  cudaLib = _cuda.lib;
  inherit (cudaLib) selectQuantized matchQuantized;
in
{
  _archiveIsAvailableOn =
    db: hostPlatform: sha256:
    let
      archive = db.archive.sha256.${sha256};
      inherit (archive) systemNv;
      # NOTE: We haven't moved `cudaCapabilities` &co to the platform yet, so we expect the user to `//`-merge the attribute to `hostPlatform`
      isJetson = hostPlatform.isJetson or false;
      systemStringMatches =
        (isJetson -> db.system.isJetson.${systemNv} or false)
        && lib.hasAttr db.system.fromNvidia.${systemNv} hostPlatform.system;
      constraintsSatisfied = builtins.all lib.id (
        pname: constraints: lib.mapAttrsToList (sign: version: false)
      ) archive.extraConstraints;
    in
    systemStringMatches && constraintsSatisfied;

  solveGreedy =
    {
      hostPlatform,

      # ∷ ProductName ⇒ VersionString
      pinProducts ? {
        cuda = "12.8.1"; # Example value, for playing in REPL
        # cudnn = "9.7.1"; # Supported by TRT
      },

      # ∷ PName ⇒ VersionString
      pinPackages ? {
      },
    }:

    let
      # Vendor temporarily for REPL usage
      mkVersionedPackageName =
        name: version: name + "_" + lib.replaceStrings [ "." ] [ "_" ] (lib.versions.majorMinor version);

      # ∷ Maybe T → T → T
      maybeOr = maybe: default: if maybe != null then maybe else default;

      inherit (_cuda) db;

      unrecognizedProducts = lib.filterAttrs (
        name: version: selectQuantized db.release.package.${name} version == null
      ) pinProducts;
      unrecognizedPackages = lib.filterAttrs (
        name: version: selectQuantized db.package.version.${name} version == null
      ) pinPackages;

      formatPins =
        pins: lib.concatStringsSep ", " (lib.mapAttrsToList (name: version: "${name}:${version}") pins);
      formatUnrecognized = kind: errors: ''
        Requested ${kind} are not in `_cuda.db`: ${formatPins errors}
      '';
    in

    assert lib.assertMsg (unrecognizedProducts == { }) (
      formatUnrecognized "products" unrecognizedProducts
    );
    assert lib.assertMsg (unrecognizedPackages == { }) (
      formatUnrecognized "packages" unrecognizedPackages
    );

    let
      archiveIsSupported = archiveIsSupported' db hostPlatform; # ∷ { systemNv, extraConstraints, ... } → Bool
      archiveIsSupported' =
        db: hostPlatform: archive:
        let
          inherit (archive) systemNv;
          # NOTE: We haven't moved `cudaCapabilities` &co to the platform yet, so we expect the user to `//`-merge the attribute to `hostPlatform`
          isJetson = hostPlatform.isJetson or false;
          systemStringMatches =
            (isJetson -> db.system.isJetson.${systemNv} or false)
            && lib.hasAttr hostPlatform.system db.system.fromNvidia.${systemNv};
          constraintsSatisfied = testAllConstraints archive.extraConstraints;
        in
        systemStringMatches && constraintsSatisfied;

      testAllConstraints =
        constraints: builtins.all lib.id (lib.mapAttrsToList testDepConstraints constraints);
      testDepConstraints =
        depName: inequalities:
        testDepConstraints' solution.${depName}.version or pinProducts.${depName} inequalities;
      testDepConstraints' =
        depVersion: inequalities:
        builtins.all lib.id (
          lib.mapAttrsToList (
            sign: version: version == null || predicates.${sign} depVersion version
          ) inequalities
        );
      predicates = {
        "<" = lib.versionOlder;
        ">=" = lib.versionAtLeast;
      };

      # ∷ PName ⇒ VersionString
      pinnedVersions =
        lib.concatMapAttrs (
          productName: productVersion:
          maybeOr (selectQuantized db.release.package.${productName} productVersion) { }
        ) pinProducts
        // lib.mapAttrs (
          pname: version:
          lib.last (
            lib.attrNames (
              lib.filterAttrs (versionKey: _: matchQuantized version versionKey) db.package.version.${pname}
            )
          )
        ) pinPackages;

      # ∷ PName → { version: VersionString, blobs: SHA256 ⇒ { URL, SystemStringNvidia... } }
      latestSupported' =
        pname:
        lib.last (
          [ null ]
          ++ lib.mapAttrsToList (version: blobs: { inherit version blobs; }) supportedArchives.${pname}
        );

      # ∷ PName ⇒ { version: VersionString, blobs: SHA256 ⇒ { URL, SystemStringNvidia... } }
      latestSupported = lib.mapAttrs (pname: _: latestSupported' pname) db.package.pname;

      # ∷ PName ⇒ VersionString ⇒ SHA256 ⇒ { URL, SystemStringNvidia, ... }
      supportedArchives = lib.mapAttrs (
        pname: _:
        lib.addErrorContext "while evaluating `supportedArchives' ... ${pname}`" (
          supportedArchives' db.package.version pname
        )
      ) db.package.version;

      # ∷ (PName ⇒ VersionString ⇒ SHA256 ⇒ ()) → PName ⇒ VersionString ⇒ SHA256 ⇒ { URL, SystemStringNvidia, ... }
      supportedArchives' =
        knownVersions: pname:
        lib.concatMapAttrs (
          version: hashes:
          let
            supportedBlobs = lib.concatMapAttrs (
              sha256: _:
              let
                supported = archiveIsSupported archive;
                archive = db.archive.sha256.${sha256};
              in
              lib.optionalAttrs supported { ${sha256} = archive; }
            ) hashes;
          in
          lib.optionalAttrs (supportedBlobs != { }) { ${version} = supportedBlobs; }
        ) knownVersions.${pname};

      reduceConstraints = lib.mapNullable (
        archives:
        builtins.head (
          lib.mapAttrsToList (
            sha256: archive:
            assert (
              lib.assertMsg (testAllConstraints archive.extraConstraints) "while testing constraints of ${sha256}"
            );
            lib.removeAttrs archive [ "extraConstraints" ] // { inherit sha256; }
          ) archives
        )
      );

      solution =
        # Versioned attributes (e.g. `cudnn_8_9`) kept for compatibility
        lib.flip lib.concatMapAttrs (lib.removeAttrs db.release.package [ "cuda" ]) (
          productName: productVersions:
          lib.concatMapAttrs (
            _productVersion: packageVersions:
            lib.mapAttrs' (
              pname: version:
              lib.nameValuePair (mkVersionedPackageName productName version) {
                inherit pname version;
                src = reduceConstraints (supportedArchives.${pname}.${version} or null);
              }
            ) packageVersions
          ) productVersions
        )
        # Unversioned attributes (e.g. `cudnn`) take priority
        // lib.flip lib.mapAttrs db.package.pname (
          pname: _: rec {
            inherit pname;
            version = maybeOr pinnedVersions.${pname} or null latestSupported.${pname}.version or "UNSUPPORTED";
            src = reduceConstraints (supportedArchives.${pname}.${version} or null);
          }
        );
    in

    assert builtins.all lib.id (
      lib.mapAttrsToList (pname: version: matchQuantized solution.${pname}.version version) pinnedVersions
    );

    lib.addErrorContext
      "while evaluating _cuda/db/greedy.nix for products: ${formatPins pinProducts}, packages: ${formatPins pinPackages}"

      # ∷ AttrName ⇒ { PName, Maybe Version, Maybe { SHA256, URL, SystemStringNvidia, ... } }
      solution;
}
