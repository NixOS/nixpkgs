{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, isPy3k
, python
, applicationinsights
, portalocker
}:

buildPythonPackage rec {
  pname = "azure-cli-telemetry";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f239d544d309c29e827982cc20113eb57037dba16db6cdd2e0283e437e0e577";
  };

  propagatedBuildInputs = [
    applicationinsights
    portalocker
  ];

  # tests are not published to pypi
  doCheck = false;

  # Remove overly restrictive version contraints and obsolete namespace setup
  prePatch = ''
    substituteInPlace setup.py \
      --replace "applicationinsights>=0.11.1,<0.12" "applicationinsights"
    substituteInPlace setup.cfg \
      --replace "azure-namespace-package = azure-cli-nspkg" ""
    rm azure_bdist_wheel.py # we'll fix PEP420 namespacing
  '';

  # Prevent these __init__'s from violating PEP420, only needed for python2
  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py \
       $out/${python.sitePackages}/azure/cli/__init__.py
  '';

  meta = with lib; {
    homepage = https://github.com/Azure/azure-cli;
    description = "Next generation multi-platform command line experience for Azure";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
