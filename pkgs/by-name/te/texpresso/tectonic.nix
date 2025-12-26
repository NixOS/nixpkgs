{
  tectonic-unwrapped,
  fetchFromGitHub,
  rustPlatform,
}:

tectonic-unwrapped.overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "texpresso-tonic";
    version = "0.15.0-unstable-2024-04-19";
    src = fetchFromGitHub {
      owner = "let-def";
      repo = "tectonic";
      rev = "b38cb3b2529bba947d520ac29fbb7873409bd270";
      hash = "sha256-ap7fEPHsASAphIQkjcvk1CC7egTdxaUh7IpSS5os4W8=";
      fetchSubmodules = true;
    };

    cargoHash = "sha256-mqhbIv5r/5EDRDfP2BymXv9se2NCKxzRGqNqwqbD9A0=";
    # rebuild cargoDeps by hand because `.overrideAttrs cargoHash`
    # does not reconstruct cargoDeps (a known limitation):
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      name = "${finalAttrs.pname}-${finalAttrs.version}";
      hash = finalAttrs.cargoHash;
      patches = finalAttrs.cargoPatches;
    };
    # binary has a different name, bundled tests won't work
    doCheck = false;
    postInstall = ''
      ${prevAttrs.postInstall or ""}

      # Remove the broken `nextonic` symlink
      # It points to `tectonic`, which doesn't exist because the exe is
      # renamed to texpresso-tonic
      rm $out/bin/nextonic
    '';
    meta = prevAttrs.meta // {
      mainProgram = "texpresso-tonic";
    };
  }
)
