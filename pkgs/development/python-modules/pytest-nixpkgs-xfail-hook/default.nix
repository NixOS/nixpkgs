{ lib
, buildPythonPackage
, hatchling
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-nixpkgs-xfail-hook";
  version = "1.0.0";
  pyproject = true;

  src = ./src;

  nativeBuildInputs = [ hatchling ];
  buildInputs = [ pytest ];

  doCheck = false; # no checks

  pythonImportsCheck = [ "pytest_nixpkgs_xfail_hook" ];

  meta = {
    description = "Used in pytestCheckXfailHook";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
