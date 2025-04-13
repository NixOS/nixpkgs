{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, httpx
, h2
, pydantic
, pyjwt
, pytest-mock
}:

buildPythonPackage rec {
  pname = "gotrue";
  version = "2.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ueoWTuUpZNg2TFUM3hbdDpV2JBpM/+qlLsozn2HR0Us=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    httpx
    h2
    pydantic
    pyjwt
    pytest-mock
  ];

  pythonImportsCheck = [ "gotrue" ];

  # test aren't in pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase/auth-py.git";
    license = licenses.mit;
    description = "Python Client Library for Supabase Auth";
    maintainers = with maintainers; [ siegema ];
  };
}
