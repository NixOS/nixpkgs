{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, importlib-metadata
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "freebox-api";
  version = "0.0.10";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yUcHdSHSgWxZl0z7Ue0MestvGhiXkDsxArNoDk0ZkR4=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/hacf-fr/freebox-api/pull/187
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/hacf-fr/freebox-api/commit/07356ac65483bc24fb1ed32612e77f2c2eed0134.patch";
      sha256 = "1zwricrwsqy01pmhrjy41gh4kxb3gki8z8yxlpywd66y7gid547r";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "freebox_api" ];

  meta = with lib; {
    description = "Python module to interact with the Freebox OS API";
    homepage = "https://github.com/hacf-fr/freebox-api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
