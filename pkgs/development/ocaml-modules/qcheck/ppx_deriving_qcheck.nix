{
  buildDunePackage,
  fetchFromGitHub,
  qcheck,
  ppxlib,
  ppx_deriving,
}:

buildDunePackage {
  pname = "ppx_deriving_qcheck";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    tag = "v0.24";
    hash = "sha256-iuFlmSeUhumeWhqHlaNqDjReRf8c4e76hhT27DK3+/g=";
  };

  propagatedBuildInputs = [
    qcheck
    ppxlib
    ppx_deriving
  ];

  meta = qcheck.meta // {
    description = "PPX Deriver for QCheck";
  };
}
