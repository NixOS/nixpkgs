{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  httpx,
  h2,
  pydantic,
  pyjwt,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "gotrue";
  version = "2.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ueoWTuUpZNg2TFUM3hbdDpV2JBpM/+qlLsozn2HR0Us=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    h2
    pydantic
    pyjwt
    pytest-mock
  ];

  pythonImportsCheck = [ "gotrue" ];

  # test aren't in pypi package
  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase/auth-py";
    license = lib.licenses.mit;
    description = "Python Client Library for Supabase Auth";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
