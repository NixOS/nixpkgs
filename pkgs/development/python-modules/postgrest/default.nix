{ lib
, pkgs
, python3Packages
, fetchPypi
, poetry-core
}:

python3Packages.buildPythonPackage rec {
  pname = "postgrest";
  version = "0.16.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bFyOU83O3otmVN38dQXlrwxBzlbGk197HQVUW7iZ2Lg=";
  };

  propagatedBuildInputs = with python3Packages; [
    httpx
    deprecation
    pydantic
    strenum
  ];

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];


  # tests are not in pypi package
  doCheck = false;


  meta = with lib; {
    homepage = "https://github.com/supabase-community/auth-py";
    license = licenses.mit;
    description = "Python Postgrest Client for Supabase";
    mainProgram = "postgrest";
    maintainers = with maintainers; [ samrose ];
  };
}
