{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gsd";
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-huMM98An/DG8PIVblS3b6AxF6vJ5IoKOs1f9kBnR3ik=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gsd" ];

  preCheck = ''
    pushd gsd/test
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "General simulation data file format";
    mainProgram = "gsd";
    homepage = "https://github.com/glotzerlab/gsd";
    changelog = "https://github.com/glotzerlab/gsd/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
