{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pycfdns";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pycfdns";
    tag = version;
    hash = "sha256-bLzDakxKq8fcjEKSxc6D5VN9gfAu1M3/zaAU2UYnwSs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version="0",' 'version="${version}",'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pycfdns" ];

  meta = {
    description = "Python module for updating Cloudflare DNS A records";
    homepage = "https://github.com/ludeeus/pycfdns";
    changelog = "https://github.com/ludeeus/pycfdns/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
