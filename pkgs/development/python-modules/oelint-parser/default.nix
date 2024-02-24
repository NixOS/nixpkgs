{ lib
, nix-update-script
, fetchPypi
, buildPythonPackage
, deprecated
, regex
, pip
}:

buildPythonPackage rec {
  pname = "oelint-parser";
  version = "3.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "oelint_parser";
    hash = "sha256-pjdPiM23jITqYW5dklJJN5X8C8OmetIDvpN/RCLMWoE=";
  };

  buildInputs = [ pip ];
  propagatedBuildInputs = [
    deprecated
    regex
  ];
  pythonImportsCheck = [ "oelint_parser" ];

  # Fail to run inside the code the build.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Alternative parser for bitbake recipes";
    homepage = "https://github.com/priv-kweihmann/oelint-parser";
    changelog = "https://github.com/priv-kweihmann/oelint-parser/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ otavio ];
  };
}
