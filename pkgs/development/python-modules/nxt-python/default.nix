{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pybluez,
  pytestCheckHook,
  pythonOlder,
  pyusb,
}:

buildPythonPackage rec {
  pname = "nxt-python";
  version = "3.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "schodet";
    repo = "nxt-python";
    tag = version;
    hash = "sha256-ffJ7VhXT5I7i5JYfnjFBaud0CxoVBFWx6kRdAz+Ry00=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pyusb ];

  optional-dependencies = {
    bluetooth = [ pybluez ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nxt" ];

  meta = with lib; {
    description = "Python driver/interface for Lego Mindstorms NXT robot";
    homepage = "https://github.com/schodet/nxt-python";
    changelog = "https://github.com/schodet/nxt-python/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ibizaman ];
  };
}
