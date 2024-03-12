{ lib
, buildPythonPackage
, fetchFromGitHub
, pybluez
, pytestCheckHook
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "nxt-python";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "schodet";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PWeR8xteLMxlOHcJJCtTI0o8QNzwGJVkUACmvf4tXWY=";
  };

  propagatedBuildInputs = [
    pyusb
  ];

  passthru.optional-dependencies = {
    bluetooth = [
      pybluez
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nxt"
  ];

  meta = with lib; {
    description = "Python driver/interface for Lego Mindstorms NXT robot";
    homepage = "https://github.com/schodet/nxt-python";
    changelog = "https://github.com/schodet/nxt-python/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ibizaman ];
  };
}
