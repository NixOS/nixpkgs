{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.159";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hBlwfyQ1PbD6AyCsra2yZwt0x8+iGtDisU9coTSJRZI=";
  };

  nativeBuildInputs = [
    setuptools
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
    maintainers = with maintainers; [ copumpkin phaer ];
  };
}
