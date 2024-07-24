{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "krakenex";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "veox";
    repo = "python3-krakenex";
    rev = "v${version}";
    hash = "sha256-htldEds3vf9bjFkJAew0e0fHDLD15OTcVYybSmIp3DI=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "krakenex" ];

  meta = with lib; {
    changelog = "https://github.com/veox/python3-krakenex/blob/${src.rev}/CHANGELOG.rst";
    description = "Kraken.com cryptocurrency exchange API";
    homepage = "https://github.com/veox/python3-krakenex";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
