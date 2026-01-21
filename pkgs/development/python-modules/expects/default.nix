{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "expects";
  version = "0.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jaimegildesagredo";
    repo = "expects";
    rev = "v${version}";
    sha256 = "0mk1mhh8n9ly820krkhazn1w96f10vmgh21y2wr44sn8vwr4ngyy";
  };

  # mamba is used as test runner. Not available and should not be used as
  # it's just another unmaintained test runner.
  doCheck = false;
  pythonImportsCheck = [ "expects" ];

  meta = {
    description = "Expressive and extensible TDD/BDD assertion library for Python";
    homepage = "https://expects.readthedocs.io/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
