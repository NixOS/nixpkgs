{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  isal,
  zlib-ng,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiohttp-fast-zlib";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohttp-fast-zlib";
    rev = "v${version}";
    hash = "sha256-nR/0hVe5zAhLXu+kBOBH+whIjUV44c5yuNOj+Zl+eFo=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  optional-dependencies = {
    isal = [ isal ];
    zlib_ng = [ zlib-ng ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "aiohttp_fast_zlib" ];

  meta = with lib; {
    description = "Use the fastest installed zlib compatible library with aiohttp";
    homepage = "https://github.com/bdraco/aiohttp-fast-zlib";
    changelog = "https://github.com/bdraco/aiohttp-fast-zlib/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
