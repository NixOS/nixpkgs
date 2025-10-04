{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "raven";
  version = "1.0.0_alpha1";

  src = fetchFromGitHub {
    owner = "raven-ml";
    repo = "raven";
    tag = finalAttrs.version;
    hash = "sha256-2D7jH59q7y7KwJjjyYa9nySNK5e2g9Hf49wGroCnhYs";
  };

  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow iokit-open)
    (allow file-read* (subpath "/System/Library/Extensions"))
    (allow mach-lookup (global-name "com.apple.MTLCompilerService"))
  '';

  passthru = {
    inherit (finalAttrs) sandboxProfile;
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
})
