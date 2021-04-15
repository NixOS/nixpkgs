{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, typing-extensions
, toml
, zipp
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "3.7.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "742add720a20d0467df2f444ae41704000f50e1234f46174b51f9c6031a1bd71";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    toml
    zipp
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;
  pythonImportsCheck = [ "importlib_metadata" ];

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
