{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  pydantic,
  python-dateutil,
  typing-extensions,
  urllib3,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lance-namespace";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance-namespace";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-t6VCKG54Sxf92B1OmfXXsWaJww2fyEcMGpJy4z94HZs=";
=======
    hash = "sha256-OqSaDe0xA1S/KphpwJuIcyOrcT9sq+0oHhiIBtd7bcY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${src.name}/python/lance_namespace_urllib3_client";

  build-system = [
    hatchling
  ];

  dependencies = [
    pydantic
    python-dateutil
    typing-extensions
    urllib3
  ];

  pythonImportsCheck = [ "lance_namespace_urllib3_client" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Lance namespace OpenAPI specification";
    homepage = "https://github.com/lancedb/lance-namespace/tree/main/python/lance_namespace_urllib3_client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
