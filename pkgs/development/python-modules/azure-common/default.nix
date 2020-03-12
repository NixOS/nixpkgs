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
  version = "1.1.24";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "184ad6a05a3089dfdc1ce07c1cbfa489bbc45b5f6f56e848cac0851e6443da21";
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
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
