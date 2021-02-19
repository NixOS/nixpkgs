{ lib
, asyncssh
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioasuswrt";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = pname;
    rev = "V${version}";
    sha256 = "0bzl11224vny4p9vhi1n5s9p04kfavdzs9xkq5qimbisz9sg4ysj";
  };

  patches = [
    (fetchpatch {
      # Remove pytest-runner, https://github.com/kennedyshead/aioasuswrt/pull/63
      url = "https://github.com/kennedyshead/aioasuswrt/pull/63/commits/e7923927648d5d8daccac1716db86db2a45fcb34.patch";
      sha256 = "09xzs3hjr3133li6b7lr58n090r00kaxi9hx1fms2zn0ai4xwp9d";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report html" "" \
      --replace "--cov-report term-missing" ""
  '';

  propagatedBuildInputs = [ asyncssh ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioasuswrt" ];

  meta = with lib; {
    description = "Python module for Asuswrt";
    homepage = "https://github.com/kennedyshead/aioasuswrt";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
