{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  authlib,
  click,
  koji,
  munch,
  requests,
  requests-kerberos,
}:

buildPythonPackage rec {
  pname = "bodhi-client";
  version = "26.11.0";
  pyproject = true;

  src = fetchPypi {
    pname = "bodhi_client";
    inherit version;
    hash = "sha256-T/O2JLuqrY8wYBPF0Pwz8scUP+8JRkFOFmGS0Z2cmFc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    authlib
    click
    koji
    munch
    requests
    requests-kerberos
  ];

  pythonImportsCheck = [ "bodhi.client" ];

  meta = {
    description = "Command line client for Bodhi, Fedora's update gating system";
    homepage = "https://github.com/fedora-infra/bodhi";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "bodhi";
  };
}
