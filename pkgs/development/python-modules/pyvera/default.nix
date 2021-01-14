{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-cov
, pytest-asyncio
, pytest-timeout
, responses
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "pyvera";
  version = "0.3.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = pname;
    rev = version;
    sha256 = "0yi2cjd3jag95xa0k24f7d7agi26ywb3219a0j0k8l2nsx2sdi87";
  };

  patches = [
    (fetchpatch {
      # build-system section is missing https://github.com/pavoni/pyvera/pull/142
      url = "https://github.com/pavoni/pyvera/pull/142/commits/e90995a8d55107118d324e8cf189ddf1d9e3aa6c.patch";
      sha256 = "1psq3fiwg20kcwyybzh5g17dzn5fh29lhm238npyg846innbzgs7";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytest-cov
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "pyvera" ];

  meta = with lib; {
    description = "Python library to control devices via the Vera hub";
    homepage = "https://github.com/pavoni/pyvera";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
