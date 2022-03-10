{ buildPythonPackage, fetchFromGitHub, lib, poetry-core, pyspark }:

buildPythonPackage rec {
  pname = "chispa";
  version = "0.8.3";
  format = "pyproject";

  src = fetchFromGitHub {
    repo = "chispa";
    owner = "MrPowers";
    rev = "v${version}";
    sha256 = "sha256-1ePx8VbU8pMd5EsZhFp6qyMptlUxpoCvJfuDm9xXOdc=";
  };

  checkInputs = [ pyspark ];

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "chispa" ];

  meta = with lib; {
    homepage = "https://github.com/MrPowers/chispa";
    description = "PySpark test helper methods with beautiful error messages";
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
}
