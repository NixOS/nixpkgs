{
  buildDunePackage,
  raven,
  raven-nx,
  alcotest,
  csv,
  ocurl,
  openblas,
}:

buildDunePackage {
  pname = "nx-datasets";

  inherit (raven) version src sandboxProfile;

  propagatedBuildInputs = [
    raven-nx
    csv
    ocurl
  ];

  doCheck = false;

  checkInputs = [
    alcotest
    openblas.dev
  ];

  meta = raven.meta // {
    description = "Common datasets for machine learning";
    longDescription = ''
      A collection of common datasets for machine learning tasks, including image classification, regression, and more.
      This package provides easy access to popular datasets in a format compatible with Nx.
    '';
  };
}
