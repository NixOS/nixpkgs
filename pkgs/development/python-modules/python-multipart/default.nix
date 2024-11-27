{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  mock,
  pyyaml,
  six,

  # for passthru.tests
  asgi-csrf,
  connexion,
  fastapi,
  gradio,
  starlette,
}:

buildPythonPackage rec {
  pname = "python-multipart";
  version = "0.0.12";
  pyproject = true;

  src = fetchPypi {
    pname = "python_multipart";
    inherit version;
    hash = "sha256-BF4fmNcZwc4IXtf34e+djMyMAroCtVZtX3UhQQztWMs=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "multipart" ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pyyaml
  ];

  passthru.tests = {
    inherit
      asgi-csrf
      connexion
      fastapi
      gradio
      starlette
      ;
  };

  meta = with lib; {
    description = "Streaming multipart parser for Python";
    homepage = "https://github.com/andrew-d/python-multipart";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
