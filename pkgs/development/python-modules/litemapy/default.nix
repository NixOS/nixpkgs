{ lib
, buildPythonPackage
, fetchFromGitHub
, nbtlib
}:

buildPythonPackage rec {
  pname = "litemapy";
  version = "0.7.2b0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SmylerMC";
    repo = "litemapy";
    rev = "v${version}";
    hash = "sha256-VfEo/JLeU17bEkvc8oZYfq19RsHl6QvKv0sGZYQjYhE=";
  };

  propagatedBuildInputs = [
    nbtlib
  ];

  pythonImportsCheck = [ "litemapy" ];

  meta = with lib; {
    description = "A Python library to read and edit Litematica's schematic file format";
    homepage = "https://github.com/SmylerMC/litemapy";
    changelog = "https://github.com/SmylerMC/litemapy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gdd ];
  };
}
