{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncstdlib";
  version = "3.9.1";
  disabled = pythonOlder "3.7";
  format = "flit";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = pname;
    rev = "v${version}";
    sha256 = "13ranr7zi61w52vfrxwkf32bbhk88j0r5c5z2x2h5vw268001lk2";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asyncstdlib" ];

  meta = with lib; {
    description = "Python library that extends the Python asyncio standard library";
    homepage = "https://asyncstdlib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
