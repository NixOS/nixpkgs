{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  ply,
  poetry-core,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pysmi-lextudio";
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysmi";
    rev = "refs/tags/v${version}";
    hash = "sha256-JrWVoK7fqESUIJeprjB28iaqOEWgsTpTqUEmSZp9XDk=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    jinja2
    ply
    requests
  ];

  # Circular dependency on pysnmp-lextudio
  doCheck = false;

  pythonImportsCheck = [ "pysmi" ];

  meta = with lib; {
    description = "SNMP MIB parser";
    homepage = "https://github.com/lextudio/pysmi";
    changelog = "https://github.com/lextudio/pysmi/blob/v${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
