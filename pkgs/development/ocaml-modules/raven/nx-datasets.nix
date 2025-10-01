{
  buildDunePackage,
  alcotest,
  csv,
  ocurl,
  raven,
  raven-nx,
}:

buildDunePackage {
  pname = "nx-datasets";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    csv
    ocurl
    raven-nx
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];

  meta = raven.meta // {
    description = "Common datasets for machine learning";
    longDescription = ''
      A collection of common datasets for machine learning tasks, including image classification, regression, and more.
      This package provides easy access to popular datasets in a format compatible with Nx.
    '';
  };
}
