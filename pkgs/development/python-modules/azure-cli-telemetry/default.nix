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
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sf27pcz653h0cnxsg47nndilhqlw9fl019aqbnji2vn967r9rnl";
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
      --replace "applicationinsights>=0.11.1,<0.11.8" "applicationinsights" \
      --replace "portalocker==1.2.1" "portalocker"
    substituteInPlace setup.cfg \
      --replace "azure-namespace-package = azure-cli-nspkg" ""
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
