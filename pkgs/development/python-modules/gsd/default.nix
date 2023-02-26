{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gsd";
  version = "2.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-S2BEEGifHt4ZXOxCEtwXh7wr/n1fI+gwImnrEJmYjzI=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gsd"
  ];


  preCheck = ''
    pushd gsd/test
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "General simulation data file format";
    homepage = "https://github.com/glotzerlab/gsd";
    changelog = "https://github.com/glotzerlab/gsd/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ costrouc ];
  };
}
