{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pythonOlder
}:
let
  # Pex requires hatchlings <1.22 atm, but plans to upgrade as per comment in their pyproject.toml
  # https://github.com/pex-tool/pex/commit/ae6094d66d298eb0a6cd42caadba62fd9a7fe796#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711
  hatchling_1_21 = hatchling.overridePythonAttrs (old: rec {
    version = "1.21.1";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      hash = "sha256-u6RARToiTn1EeEV/oujYw2M3Zbr6Apdaa1O5v5F5gLw=";
    };
  });
in
buildPythonPackage rec {
  pname = "pex";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0SZMkRYcIRObRUdEyAU+Jbiq0tFdqJIyGBtPOPP1RXU=";
  };

  build-system = [
    hatchling_1_21
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
