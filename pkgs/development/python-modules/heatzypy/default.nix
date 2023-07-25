{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "heatzypy";
  version = "2.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Cyr-ius";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Z60apquRzhkPbxgGKgDswtW9GUXGt9MbdAsh3Yh31b0=";
  };

  postPatch = ''
    # https://github.com/Cyr-ius/heatzypy/issues/7
    substituteInPlace setup.py \
      --replace 'version="replace_by_workflow"' 'version="${version}"'
  '';

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "heatzypy"
  ];

  meta = with lib; {
    description = "Python module to interact with Heatzy devices";
    homepage = "https://github.com/Cyr-ius/heatzypy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
