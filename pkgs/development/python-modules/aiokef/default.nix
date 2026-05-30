{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  tenacity,
}:

buildPythonPackage rec {
  pname = "aiokef";
  version = "0.2.17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "aiokef";
    rev = "v${version}";
    sha256 = "0ms0dwrpj80w55svcppbnp7vyl5ipnjfp1c436k5c7pph4q5pxk9";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--mypy" ""
  '';

  propagatedBuildInputs = [
    async-timeout
    tenacity
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  enabledTestPaths = [ "tests" ];
  pythonImportsCheck = [ "aiokef" ];

  meta = {
    description = "Python API for KEF speakers";
    homepage = "https://github.com/basnijholt/aiokef";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
