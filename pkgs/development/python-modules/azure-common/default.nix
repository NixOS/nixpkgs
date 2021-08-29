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
  version = "1.1.27";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "9f3f5d991023acbd93050cf53c4e863c6973ded7e236c69e99c8ff5c7bad41ef";
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
