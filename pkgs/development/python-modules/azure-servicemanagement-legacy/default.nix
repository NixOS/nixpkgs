{ pkgs
, buildPythonPackage
, fetchPypi
, azure-common
, requests
, python
}:

buildPythonPackage rec {
  version = "0.20.1";
  pname = "azure-servicemanagement-legacy";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "17dwrp99sx5x9cm4vldkaxhki9gbd6dlafa0lpr2n92xhh2838zs";
  };

  propagatedBuildInputs = [ azure-common requests ];

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
  '';

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
