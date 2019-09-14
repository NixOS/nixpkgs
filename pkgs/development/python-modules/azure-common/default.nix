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
  version = "1.1.21";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "25d696d2affbf5fe9b13aebe66271fce545e673e7e1eeaaec2d73599ba639d63";
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
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-common;
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
