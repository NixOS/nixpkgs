{ lib
, buildPythonPackage
, fetchPypi
, azure-nspkg
, isPyPy
, setuptools
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "1.1.28";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-SsDNMhTja2obakQmhnIqXYzESWA6qDPz8PQL2oNnBKM=";
  };

  propagatedBuildInputs = [
    azure-nspkg
  ] ++ lib.optionals (!isPy3k) [ setuptools ]; # need for namespace lookup

  postInstall = if isPy3k then "" else ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
  '';

  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure common code";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
