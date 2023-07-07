{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, prompt-toolkit
, pycryptodome
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pykoplenti";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stegm";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XBOKf3i8xywU/1Kzl+VI1Qnkp9ohpSuDX3AnotD32oo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    # remove with 1.1.0
    substituteInPlace setup.cfg \
      --replace 'version = unreleased' 'version = ${version}'
  '';

  propagatedBuildInputs = [
    aiohttp
    click
    prompt-toolkit
    pycryptodome
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykoplenti" ];

  meta = with lib; {
    description = "Python REST client API for Kostal Plenticore Inverters";
    homepage = "https://github.com/stegm/pykoplenti/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
