{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioopenssl";
  version = "0.6.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "horazont";
    repo = "aioopenssl";
    rev = "refs/tags/v${version}";
    hash = "sha256-7Q+4/DlP+kUnC3YNk7woJaxLEEiuVmolUOajepM003Q=";
  };

  propagatedBuildInputs = [
    pyopenssl
  ];

  pythonImportsCheck = [ "aioopenssl" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "TLS-capable transport using OpenSSL for asyncio";
    homepage = "https://github.com/horazont/aioopenssl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
