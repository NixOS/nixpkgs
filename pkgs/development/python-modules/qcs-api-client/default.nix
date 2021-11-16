{ lib
, attrs
, buildPythonPackage
, fetchPypi
, httpx
, iso8601
, pydantic
, pyjwt
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
, respx
, retrying
, rfc3339
, toml
}:

buildPythonPackage rec {
  pname = "qcs-api-client";
  version = "0.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ac6cf55e414494095ac1e1258f5700fed8eefa37d3b8da80264bd674cbfac43";
  };

  propagatedBuildInputs = [
    attrs
    httpx
    iso8601
    pydantic
    pyjwt
    python-dateutil
    retrying
    rfc3339
    toml
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "attrs>=20.1.0,<21.0.0" "attrs" \
      --replace "httpx>=0.15.0,<0.16.0" "httpx" \
      --replace "pyjwt>=1.7.1,<2.0.0" "pyjwt"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "qcs_api_client"
  ];

  meta = with lib; {
    description = "Python library for accessing the Rigetti QCS API";
    homepage = "https://pypi.org/project/qcs-api-client/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
