{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiosasl";
  version = "0.5.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "horazont";
    repo = "aiosasl";
    rev = "refs/tags/v${version}";
    hash = "sha256-JIuNPb/l4QURMQc905H2iNGCfMz+zM/QJhDQOR8LPdc=";
  };

  patches = [
    (fetchpatch {
      name = "python311-compat.patch";
      url = "https://github.com/horazont/aiosasl/commit/44c48d36b416bd635d970dba2607a31b2167ea1b.patch";
      hash = "sha256-u6PJKV54dU2MA9hXa/9hJ3eLVds1DuLHGbt8y/OakWs=";
    })
  ];

  nativeCheckInputs = [
    pyopenssl
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosasl" ];

  meta = {
    description = "Asyncio SASL library";
    homepage = "https://github.com/horazont/aiosasl";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
