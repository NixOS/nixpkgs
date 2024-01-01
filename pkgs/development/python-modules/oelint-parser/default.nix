{ lib
, nix-update-script
, fetchPypi
, buildPythonPackage
, regex
, pip
}:

buildPythonPackage rec {
  pname = "oelint-parser";
  version = "2.12.3";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "oelint_parser";
    hash = "sha256-fzHEy9/BxstPAYhVTG0o7Gn2D9UKuSZvI0X5ynZ+oEk=";
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
