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
  version = "0.0.9";
  pyproject = true;

  src = fetchPypi {
    pname = "python_multipart";
    inherit version;
    hash = "sha256-A/VGiMZj8beXcQXwIQQ7B5MVHkyxwanUoR/BPWIsQCY=";
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
    description = "A streaming multipart parser for Python";
    homepage = "https://github.com/andrew-d/python-multipart";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
