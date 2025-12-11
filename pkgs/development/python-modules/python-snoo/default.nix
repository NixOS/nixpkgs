{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  aiomqtt,
  freenub,
  mashumaro,
}:

buildPythonPackage rec {
  pname = "python-snoo";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "python-snoo";
    tag = "v${version}";
    hash = "sha256-p0cKIDdSQwryagvHGjydSTR4O5lAPO7UMhw+tSIxZrY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail poetry-core==1.8.0 poetry-core
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiomqtt
    freenub
    mashumaro
  ];

  pythonImportsCheck = [ "python_snoo" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/Lash-L/python-snoo/blob/${src.tag}/CHANGELOG.md";
    description = "Control Snoo devices via python and get auto updates";
    homepage = "https://github.com/Lash-L/python-snoo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
