{
  lib,
  aiohttp,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  tenacity,
}:

buildPythonPackage rec {
  pname = "linear-garage-door";
  version = "0.2.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "IceBotYT";
    repo = "linear-garage-door";
    rev = "refs/tags/${version}";
    hash = "sha256-ibOCqy7krIVC7N75SwEyUII3Tknb60nwA+zGbjOENv4=";
  };

  postPatch = ''
    sed -i pyproject.toml \
      -e "/--cov/d" \
      -e "/--no-cov/d"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    dnspython
    tenacity
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "linear_garage_door" ];

  meta = with lib; {
    description = "Control Linear Garage Doors with Python";
    homepage = "https://github.com/IceBotYT/linear-garage-door";
    changelog = "https://github.com/IceBotYT/linear-garage-door/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
