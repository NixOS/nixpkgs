{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.131";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eG1giXUuQfxROe0H8ZhU0qde8LZwRXy6YCiT54mZ6q4=";
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
