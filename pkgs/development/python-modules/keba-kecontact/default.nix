{
  lib,
  asyncio-dgram,
  buildPythonPackage,
  fetchFromGitHub,
  netifaces,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "keba-kecontact";
  version = "3.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dannerph";
    repo = "keba-kecontact";
    rev = "refs/tags/${version}";
    hash = "sha256-gR1ut2IjrU/JMy8/ZFv0jQTB6c3A/tZqtXMpQsapuj0=";
  };

  propagatedBuildInputs = [
    asyncio-dgram
    netifaces
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "keba_kecontact" ];

  meta = with lib; {
    description = "Python library for controlling KEBA charging stations";
    homepage = "https://github.com/dannerph/keba-kecontact";
    changelog = "https://github.com/dannerph/keba-kecontact/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
