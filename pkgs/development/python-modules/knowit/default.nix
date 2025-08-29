{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  babelfish,
  enzyme,
  pymediainfo,
  pyyaml,
  trakit,
  pint,
}:

# TODO(@sandarukasa): it would be nice to provide ffmpeg here
buildPythonPackage rec {
  pname = "knowit";
  version = "0.5.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "knowit";
    rev = version;
    hash = "sha256-JqzCLdXEWZyvqXpeTJRW0zhY+wVcHLuBYrJbuSqfgkg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    babelfish
    enzyme
    pymediainfo
    pyyaml
    trakit
  ];

  pythonImportsCheck = [
    "knowit"
  ];

  meta = {
    description = "Know better your media files";
    homepage = "https://github.com/ratoaq2/knowit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
}
