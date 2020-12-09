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
  version = "1.1.26";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b2866238aea5d7492cfb0282fc8b8d5f6d06fb433872345864d45753c10b6e4f";
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
