{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, requests
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-httpserver";
  version = "0.3.6";

  src = fetchPypi {
    pname = "pytest_httpserver";
    inherit version;
    sha256 = "1wdhbzv6x2v4qsqwgsc5660c4lxplh9b61vfj1zqhbhs36y96vl9";
  };

  patches = [
    (fetchpatch {
      name = "remove-pytest-runner.patch";
      url = "https://github.com/csernazs/pytest-httpserver/commit/c9752018bc2f13d141dd52c92df75c19ea388836.patch";
      sha256 = "0b76ywzl2gwddbqqlb662mfv5j42l88l5hffm7jbxzvqbz94mx3k";
    })
  ];

  propagatedBuildInputs = [ werkzeug ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "pytest_httpserver" ];

  meta = with lib; {
    description = "HTTP server for pytest to test HTTP clients";
    homepage = "https://www.github.com/csernazs/pytest-httpserver";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
