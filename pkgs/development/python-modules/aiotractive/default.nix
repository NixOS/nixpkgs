{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "aiotractive";
  version = "0.5.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = pname;
    rev = "v.${version}";
    sha256 = "04qdjyxq35063jpn218vw94a4r19fknk1q2kkxr8gnaabkpkjrnf";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiotractive" ];

  meta = with lib; {
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
