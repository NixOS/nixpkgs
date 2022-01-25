{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylaunches";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "16fh901qlcxwycq6gqgqn076dybjnj432hb596i28avaplml4qzx";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace setup.py \
      --replace 'version="main",' 'version="${version}",' \
      --replace ', "pytest-runner"' ""
  '';

  pythonImportsCheck = [
    "pylaunches"
  ];

  meta = with lib; {
    description = "Python module to get information about upcoming space launches";
    homepage = "https://github.com/ludeeus/pylaunches";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
