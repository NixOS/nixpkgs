{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioopenssl";
  version = "0.6.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "horazont";
    repo = "aioopenssl";
    tag = "v${version}";
    hash = "sha256-7Q+4/DlP+kUnC3YNk7woJaxLEEiuVmolUOajepM003Q=";
  };

  propagatedBuildInputs = [ pyopenssl ];

  pythonImportsCheck = [ "aioopenssl" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "TLS-capable transport using OpenSSL for asyncio";
    homepage = "https://github.com/horazont/aioopenssl";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
