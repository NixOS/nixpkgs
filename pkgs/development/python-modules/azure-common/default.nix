{ pkgs
, buildPythonPackage
, fetchPypi
, azure-nspkg
, isPyPy
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "1.1.23";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1qslpmwmy1bcgpf2xixidny82xwg4m4pi8bi1v63r510ixdikcak";
  };

  propagatedBuildInputs = [
    azure-nspkg
  ];

  postInstall = if isPy3k then "" else ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
  '';

  doCheck = false;

  meta = with pkgs.lib; {
    description = "This is the Microsoft Azure common code";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-common;
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
