# Wire up the alias and passthru.tests for the hercules-ci-cnix-* bindings
{
  # Latest nix version supported by haskellPackages.hercules-cnix-* bindings,
  # used in hercules-ci-agent and cachix.
  # Aliasing this separately unblocks updates that require a release of the
  # bindings.
  hercules-ci-cnix-nix-version ? "nix_2_4"

  # passthru.tests
, cachix
, hercules-ci-agent
, hci
, lib
}:

self: super:
lib.throwIfNot (lib.hasAttr hercules-ci-cnix-nix-version super)
  "Please restore nixVersions.${hercules-ci-cnix-nix-version} or update the version in ${toString ./nix-versions-overlay.nix}"
{
  hercules-ci = self.${hercules-ci-cnix-nix-version};
  # Add passthru.tests to the original def, so ofborg can always find them.
  ${hercules-ci-cnix-nix-version} = super.${hercules-ci-cnix-nix-version}.overrideAttrs (o: {
    passthru = o.passthru or { } // {
      tests = o.passthru.tests or { } // {
        inherit cachix hercules-ci-agent hci;
      };
    };
  });
}
