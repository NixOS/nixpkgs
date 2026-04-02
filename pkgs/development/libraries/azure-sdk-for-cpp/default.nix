{
  lib,
  newScope,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  curl,
  apple-sdk,
  openssl,
}:
lib.makeScope newScope (
  self:
  let
    callPackage = self.callPackage;
  in
  {
    # So you can override inputs for the entire scope easily.
    inherit
      stdenv
      cmake
      ninja
      pkg-config
      curl
      openssl
      apple-sdk
      ;

    c-shared-utility = callPackage ./c-shared-utility.nix { };
    macro-utils-c = callPackage ./macro-utils-c.nix { };
    umock-c = callPackage ./umock-c.nix { };

    core = callPackage ./core.nix { };
    core-amqp = callPackage ./core-amqp.nix { };
    core-tracing-opentelemetry = callPackage ./core-tracing-opentelemetry.nix { };
    data-tables = callPackage ./data-tables.nix { };
    identity = callPackage ./identity.nix { };
    messaging-eventhubs = callPackage ./messaging-eventhubs.nix { };
    messaging-eventhubs-checkpointstore-blob =
      callPackage ./messaging-eventhubs-checkpointstore-blob.nix
        { };
    security-attestation = callPackage ./security-attestation.nix { };
    security-keyvault-administration = callPackage ./security-keyvault-administration.nix { };
    security-keyvault-certificates = callPackage ./security-keyvault-certificates.nix { };
    security-keyvault-keys = callPackage ./security-keyvault-keys.nix { };
    security-keyvault-secrets = callPackage ./security-keyvault-secrets.nix { };
    storage-blobs = callPackage ./storage-blobs.nix { };
    storage-common = callPackage ./storage-common.nix { };
    storage-files-datalake = callPackage ./storage-files-datalake.nix { };
    storage-files-shares = callPackage ./storage-files-shares.nix { };
    storage-queues = callPackage ./storage-queues.nix { };

    meta = {
      homepage = "https://azure.github.io/azure-sdk-for-cpp";
      description = "Azure SDK for C++";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.tobim ];
      platforms = lib.platforms.all;
    };
  }
)
