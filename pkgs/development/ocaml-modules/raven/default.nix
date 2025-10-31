{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "raven";
  version = "1.0.0_alpha1-unstable-2025-10-30";

  src = fetchFromGitHub {
    owner = "raven-ml";
    repo = "raven";
    rev = "e6b6a695bbd4bf4857e73f9978876e25a166723f";
    hash = "sha256-SJVxTV8qc0c1kKYwMVcpoITrdGjtcKfSS7UuEZm/qDc=";
  };

  # remove docs to prevent pulling unnecessary dependencies during check phase
  postUnpack = ''
    rm -r $sourceRoot/{book,www}
  '';

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
