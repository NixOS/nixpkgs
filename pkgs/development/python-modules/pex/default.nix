{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.134";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hVh8N/eTJL5HpxIUkLsnD985zm1pGnD5YDgwJ/3N6dU=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  pythonImportsCheck = [
    "pex"
  ];

  meta = with lib; {
    description = "Python library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    changelog = "https://github.com/pantsbuild/pex/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
