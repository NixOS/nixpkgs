{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "anitopy";
  version = "2.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "igorcmoura";
    repo = "anitopy";
    rev = "v${version}";
    hash = "sha256-xXEf7AJKg7grDmkKfFuC4Fk6QYFJtezClyfA3vq8TfQ=";
  };

  pythonImportsCheck = [ "anitopy" ];

  meta = {
    description = "Python library for parsing anime video filenames";
    homepage = "https://github.com/igorcmoura/anitopy";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ passivelemon ];
  };
}
