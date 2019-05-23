{ pkgs
, buildPythonPackage
, fetchPypi
, azure-common
, isPyPy
, python
, msrestazure
}:

# lowPrio to avoid a collision with azure-common's azure/__init__.py file
pkgs.lib.lowPrio (buildPythonPackage rec {
  version = "1.1.0";
  pname = "azure-keyvault";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0jfxm8lx8dzs3v2b04ljizk8gfckbm5l2v86rm7k0npbfvryba1p";
  };

  propagatedBuildInputs = [ azure-common msrestazure ];

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
  '';

  meta = with pkgs.lib; {
    description = "This is the Microsoft Azure Key Vault Client Library.";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
})
