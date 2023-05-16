{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pygments
, pytestCheckHook
, uvloop
}:

buildPythonPackage rec {
  pname = "aiorun";
<<<<<<< HEAD
  version = "2023.7.2";
  format = "flit";

  disabled = pythonOlder "3.7";
=======
  version = "2022.11.1";
  format = "flit";

  disabled = pythonOlder "3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-3AGsT8IUNi5SZHBsBfd7akj8eQ+xb0mrR7ydIr3T8gs=";
=======
    hash = "sha256-1qXt3HT/0sECOqPRwc0p+5+YZh1kyHSbkZHajcrjvZc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    uvloop
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "aiorun"
  ];

  meta = with lib; {
    description = "Boilerplate for asyncio applications";
    homepage = "https://github.com/cjrh/aiorun";
    changelog = "https://github.com/cjrh/aiorun/blob/v${version}/CHANGES";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
