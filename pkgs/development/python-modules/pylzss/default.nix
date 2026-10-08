{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylzss";
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m1stadev";
    repo = "pylzss";
    tag = "v${version}";
    hash = "sha256-Y0u9rFJWYWyJUVEgpLtQHsXu0JpTgRKxFJHB+B3EFyU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lzss" ];

  # upstream's test.py is dysfunctional
  doCheck = false;

  meta = {
    changelog = "https://github.com/m1stadev/pylzss/releases/tag/${src.tag}";
    description = "Python library for decoding/encoding LZSS-compressed data";
    homepage = "https://github.com/m1stadev/pylzss";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
