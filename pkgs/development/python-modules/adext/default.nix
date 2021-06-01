{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, alarmdecoder
}:

buildPythonPackage rec {
  pname = "adext";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y9AvLgclNZdFnZJDoH6/pf8AqHr3WmwysgpJvWKicHo=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    alarmdecoder
  ];

  # Tests are not published yet
  doCheck = false;
  pythonImportsCheck = [ "adext" ];

  meta = with lib; {
    description = "Python extension for AlarmDecoder";
    homepage = "https://github.com/ajschmidt8/adext";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
