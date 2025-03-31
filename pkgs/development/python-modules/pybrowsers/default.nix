{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  pyxdg,
}:

buildPythonPackage rec {
  pname = "pybrowsers";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = "browsers";
    tag = version;
    hash = "sha256-x8sVWRT9KaKQ6obf7aFcnQFiG8FJAzu93yCzX3hnhFo=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pyxdg ];

  # Tests want to interact with actual browsers
  doCheck = false;

  pythonImportsCheck = [ "browsers" ];

  meta = with lib; {
    description = "Python library for detecting and launching browsers";
    homepage = "https://github.com/roniemartinez/browsers";
    changelog = "https://github.com/roniemartinez/browsers/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
