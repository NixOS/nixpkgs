{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
, python-gvm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gvm-tools";
  version = "21.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n9alryf52xkwxwagmq8bdn3a8scnmgh3qfdjwj6jybcyk36rv6n";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    python-gvm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/greenbone/gvm-tools/pull/520
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/greenbone/gvm-tools/commit/db65495181ca339610b1007a33cc13285a470242.patch";
      sha256 = "069rg742pxjd36vap0xp6367rd69pji4yfxbycc7z0b8gvf80w5z";
    })
  ];

  pythonImportsCheck = [ "gvmtools" ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
