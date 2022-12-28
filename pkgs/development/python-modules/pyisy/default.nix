{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, python-dateutil
, aiohttp
}:

buildPythonPackage rec {
  pname = "pyisy";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "automicus";
    repo = "PyISY";
    rev = "refs/tags/v${version}";
    hash = "sha256-95MUOxWR4YUce0fFcasKc6YjoSHTGhXJcUAg0mbXxCs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools-git-version" "" \
      --replace 'version_format="{tag}"' 'version="${version}"'
  '';

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyisy" ];

  meta = with lib; {
    description = "Python module to talk to ISY994 from UDI";
    homepage = "https://github.com/automicus/PyISY";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
