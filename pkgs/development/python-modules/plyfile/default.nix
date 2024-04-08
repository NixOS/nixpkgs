{ lib
, fetchFromGitHub
, buildPythonPackage

# build-system
, pdm-pep517

# dependencies
, numpy

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dranjan";
    repo = "python-plyfile";
    rev = "refs/tags/v${version}";
    hash = "sha256-HlyqljfjuaZoG5f2cfDQj+7KS0en7pW2PPEnpvH8U+E=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = "https://github.com/dranjan/python-plyfile";
    maintainers = with maintainers; [ abbradar ];
  };

}
