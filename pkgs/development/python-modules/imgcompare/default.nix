{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, pillow

# tests
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "imgcompare";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datenhahn";
    repo = "imgcompare";
    rev = version;
    hash = "sha256-xlDtlB89CukuXeZ2Ybhy+pDwDpR4u03izlU1ltKh5+Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pillow
  ];

  pythonImportsCheck = [
    "imgcompare"
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Compares two images for equality or a difference percentage";
    homepage = "https://github.com/datenhahn/imgcompare";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
