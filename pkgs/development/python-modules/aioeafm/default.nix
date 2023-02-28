{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioeafm";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    sha256 = "048cxn3fw2hynp27zlizq7k8ps67qq9sib1ddgirnxy5zc87vgkc";
  };

  patches = [
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/Jc2k/aioeafm/commit/549590e2ed465be40e2406416d89b8a8cd8c6185.patch";
      hash = "sha256-cG/vQI1XQO8LVvWsHrAj8KlPGRulvO7Ny+k0CKUpPqQ=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioeafm" ];

  meta = with lib; {
    description = "Python client for access the Real Time flood monitoring API";
    homepage = "https://github.com/Jc2k/aioeafm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
