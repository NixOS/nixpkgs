{ lib
, nix-update-script
, fetchPypi
, buildPythonPackage
, regex
}:

buildPythonPackage rec {
  pname = "oelint-parser";
  version = "2.11.3";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "oelint_parser";
    hash = "sha256-iR/MDHt3SEG29hSLqA36EXe8EBRZVntt+u6bwoujy0s=";
  };

  propagatedBuildInputs = [ regex ];
  pythonImportsCheck = [ "oelint_parser" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Alternative parser for bitbake recipes";
    homepage = "https://github.com/priv-kweihmann/oelint-parser";
    changelog = "https://github.com/priv-kweihmann/oelint-parser/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ otavio ];
  };
}
