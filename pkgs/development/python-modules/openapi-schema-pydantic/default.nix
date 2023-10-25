{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pydantic
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openapi-schema-pydantic";
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PiLPWLdKafdSzH5fFTf25EFkKC2ycAy7zTu5nd0GUZY=";
  };

  propagatedBuildInputs = [
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # these tests are broken with `pydantic >= 1.10`
    # but this library seems to work fine.
    # e.g. https://github.com/hwchase17/langchain/blob/d86ed15d8884d5a3f120a433b9dda065647e4534/poetry.lock#L6011-L6012
    "test_pydantic_discriminator_schema_generation"
    "test_pydantic_discriminator_openapi_generation"
  ];

  meta = with lib; {
    description = "OpenAPI (v3) specification schema as pydantic class";
    homepage = "https://github.com/kuimono/openapi-schema-pydantic";
    changelog = "https://github.com/kuimono/openapi-schema-pydantic/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
