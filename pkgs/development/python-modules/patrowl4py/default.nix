{
  lib,
  attrs,
  buildPythonPackage,
  certifi,
  chardet,
  fetchFromGitHub,
  idna,
  iniconfig,
  more-itertools,
  packaging,
  pluggy,
  py,
  pyparsing,
  python-slugify,
  requests,
  six,
  text-unidecode,
  toml,
  urllib3,
}:

buildPythonPackage rec {
  pname = "patrowl4py";
  version = "1.1.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Patrowl";
    repo = "Patrowl4py";
    rev = version;
    hash = "sha256-ZGvntLbXIWmL0WoT+kQoNT6gDPgsSKwHQQjYlarvnKo=";
  };

  propagatedBuildInputs = [
    attrs
    certifi
    chardet
    idna
    iniconfig
    more-itertools
    packaging
    pluggy
    py
    pyparsing
    python-slugify
    requests
    six
    text-unidecode
    toml
    urllib3
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "patrowl4py" ];

  meta = with lib; {
    description = "Python API Client for PatrOwl";
    homepage = "https://github.com/Patrowl/Patrowl4py";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
