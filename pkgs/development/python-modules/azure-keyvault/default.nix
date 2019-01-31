{ lib, buildPythonPackage, fetchFromGitHub
, azure-common, msrest, msrestazure }:

buildPythonPackage rec {
  pname = "azure-keyvault";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0jfxm8lx8dzs3v2b04ljizk8gfckbm5l2v86rm7k0npbfvryba1p";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests in pypi package, not sure how to do fetchFromGitHub with this monorepo
  # doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Key Vault Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-keyvault;
    maintainers= with maintainers; [ peterromfeldhk ];
    license = licenses.mit;
  };
}
