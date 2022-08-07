{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "garages-amsterdam";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "garages_amsterdam";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ZWp543msRAgn/fFplEt6saSNbZ2flC5gwjxrll4w0W0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # The only test requires network access
  doCheck = false;

  pythonImportsCheck = [
    "garages_amsterdam"
  ];

  meta = with lib; {
    description = "Python client for getting garage occupancy in Amsterdam";
    homepage = "https://github.com/klaasnicolaas/python-garages-amsterdam";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
