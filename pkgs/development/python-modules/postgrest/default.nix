{lib
, buildPythonPackage
, fetchPypi
, poetry-core
, httpx
, h2
, deprecation
, pydantic
, strenum
}:

buildPythonPackage rec {
  pname = "postgrest"; 
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DWVW2t/YOSFH2YqtCX/nvwGWYC4opY7uXpveQ5C7Vz8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    httpx
    h2
    deprecation
    pydantic
    strenum
  ];

  pythonImportsCheck = [ "postgrest" ];

  # tests aren't in the pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase/postgrest-py.git";
    description = "PostgREST client for Python. This library provides an ORM interface to PostgREST.";
    license = licenses.mit;
    maintainers = with maintainers; [ siegema ];
  };
}
