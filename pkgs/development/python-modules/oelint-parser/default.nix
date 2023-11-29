{ lib
, nix-update-script
, fetchPypi
, buildPythonPackage
, regex
, pip
}:

buildPythonPackage rec {
  pname = "oelint-parser";
  version = "2.11.6";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "oelint_parser";
    hash = "sha256-CTZxxKZPrAvuWGhwD7qAPG10rry0H71QSRXbGT0J3J0=";
  };

  buildInputs = [ pip ];
  propagatedBuildInputs = [ regex ];
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
