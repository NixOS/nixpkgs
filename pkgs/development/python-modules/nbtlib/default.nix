{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  numpy,
}:

buildPythonPackage rec {
  pname = "nbtlib";
  version = "2.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vberlier";
    repo = "nbtlib";
    rev = "v${version}";
    hash = "sha256-L8eX6/0qiQ4UxbmDicLedzj+oBjYmlK96NpljE/A3eI=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
    --replace "poetry>=0.12" "poetry-core" \
    --replace "poetry.masonry" "poetry.core.masonry"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "nbtlib" ];

  meta = with lib; {
    description = "Python library to read and edit nbt data";
    mainProgram = "nbt";
    homepage = "https://github.com/vberlier/nbtlib";
    changelog = "https://github.com/vberlier/nbtlib/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gdd ];
  };
}
