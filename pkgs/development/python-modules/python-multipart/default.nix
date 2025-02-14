{
  lib,
  buildPythonPackage,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      name = "CVE-2024-53981-part1.patch";
      url = "https://github.com/Kludex/python-multipart/commit/9205a0ec8c646b9f705430a6bfb52bd957b76c19.patch?full_index=1";
      # undo the move of multipart/ to python_multipart/
      stripLen = 2;
      extraPrefix = "multipart/";
      includes = [ "multipart/multipart.py" ];
      hash = "sha256-n/b4lvHuK8pUsuanD8htnjOiUYgDhX1N7yHlqatCuAg=";
    })
    (fetchpatch2 {
      name = "CVE-2024-53981-part2.patch";
      url = "https://github.com/Kludex/python-multipart/commit/c4fe4d3cebc08c660e57dd709af1ffa7059b3177.patch?full_index=1";
      # undo the move of multipart/ to python_multipart/
      stripLen = 2;
      extraPrefix = "multipart/";
      includes = [ "multipart/multipart.py" ];
      hash = "sha256-k/9DwHWtv/srktCwaDUGoepIdgCk872OsZdcUKZ5bjg=";
    })
  ];

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
