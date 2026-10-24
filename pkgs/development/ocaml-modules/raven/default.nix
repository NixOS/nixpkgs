{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  raven-fehu,
  raven-hugin,
  raven-kaun,
  raven-nx,
  raven-rune,
  raven-sowilo,
  raven-talon,
}:

buildDunePackage (finalAttrs: {
  pname = "raven";
  version = "1.0.0_alpha3";

  src = fetchFromGitHub {
    owner = "raven-ml";
    repo = "raven";
    tag = finalAttrs.version;
    hash = "sha256-7YUpbjrh3O6isWF3R1orfGi/C5FLg2b8YpB1ON4s3p4=";
  };

  # remove docs to prevent pulling unnecessary dependencies during check phase
  postUnpack = ''
    rm -r $sourceRoot/{doc,www}
  '';

  propagatedBuildInputs = [
    raven-fehu
    raven-hugin
    raven-kaun
    raven-nx
    raven-rune
    raven-sowilo
    raven-talon
  ];

  meta = {
    description = "Meta package for the Raven ML ecosystem";
    longDescription = ''
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
