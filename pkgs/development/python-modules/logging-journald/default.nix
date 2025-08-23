{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "logging-journald";
  version = "0.6.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "logging-journald";
    tag = version;
    hash = "sha256-L68Trq4dii25sYr3Fm2aU8w9nzpkU2F6t3OeNnny0mE=";
  };

  nativeBuildInputs = [ poetry-core ];

  # Circular dependency with aiomisc
  doCheck = false;

  pythonImportsCheck = [ "logging_journald" ];

  meta = with lib; {
    description = "Logging handler for writing logs to the journald";
    homepage = "https://github.com/mosquito/logging-journald";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
