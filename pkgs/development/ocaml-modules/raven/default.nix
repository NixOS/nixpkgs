{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "raven";
  version = "1.0.0-unstable-2025-09-19";

  src = fetchFromGitHub {
    owner = "raven-ml";
    repo = "raven";
    rev = "82b96a6bf2cef3112447ef71e065c3c31e8a8270";
    hash = "sha256-QkucSOrtkIL62VsaK3EiSHwbJOIHqnRJucVBRd7KG5g=";
  };

  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow iokit-open)
    (allow file-read* (subpath "/System/Library/Extensions"))
    (allow mach-lookup (global-name "com.apple.MTLCompilerService"))
  '';

  passthru = {
    inherit sandboxProfile;
  };

  meta = {
    description = "Meta package for the Raven ML ecosystem";
    longDistancePrefix = ''
      Raven is a comprehensive machine learning ecosystem for OCaml.
      This meta package installs all Raven components including
      Nx (tensors), Hugin (plotting), Quill (notebooks),
      Rune (autodiff), Kaun (neural networks), and Sowilo (computer vision).
    '';
    homepage = "https://raven-ml.dev";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
}
