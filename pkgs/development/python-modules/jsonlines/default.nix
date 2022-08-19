{ lib
, fetchFromGitHub
, buildPythonPackage
, attrs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonlines";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = pname;
    rev = version;
    sha256 = "sha256-eMpUk5s49OyD+cNGdAeKA2LvpXdKta2QjZIFDnIBKC8=";
  };

  propagatedBuildInputs = [ attrs ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python library to simplify working with jsonlines and ndjson data";
    homepage = "https://github.com/wbolster/jsonlines";
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };
}
