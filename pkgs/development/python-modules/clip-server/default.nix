{
  lib,
  buildPythonPackage,
  python,
  fetchPypi,
  ftfy,
  torch,
  regex,
  torchvision,
  prometheus-client,
  open-clip-torch,
  jina,
  docarray,
  pillow-avif-plugin,
}:
buildPythonPackage rec {
  pname = "clip-server";
  version = "0.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JWz5OGpZ/e9gTjnAliccQz2aWOVmnRZbFzBNLe3NyQU=";
  };

  nativeBuildInputs = with python.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    ftfy
    torch
    regex
    torchvision
    docarray
    prometheus-client
    open-clip-torch
    #pillow-avif-plugin
    jina
  ];

  pythonImportsCheck = [ "clip_server" ];

  meta = with lib; {
    description = "Embed images and sentences into fixed-length vectors via CLIP";
    homepage = "https://pypi.org/project/clip-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ oddlama onny ];
    mainProgram = "clip-server";
  };
}
