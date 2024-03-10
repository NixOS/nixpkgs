{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, numpy
, scipy
, six
, paramz
, matplotlib
, cython
}:

buildPythonPackage rec {
  pname = "GPy";
  version = "1.13.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # 1.13.0 not on PyPI yet
  src = fetchFromGitHub {
    owner = "SheffieldML";
    repo = "GPy";
    rev = "refs/tags/v.${version}";
    hash = "sha256-2HKKKBD/JFSeLQGvvgObxqxv9IHEKFnpaejdKbYZbmY=";
  };

  nativeBuildInputs = [ setuptools ];
  buildInputs = [ cython ];
  propagatedBuildInputs = [
    numpy
    scipy
    six
    paramz
    matplotlib
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  # Rebuild cython-generated .c files to ensure compatibility
  preBuild = ''
    for fn in $(find . -name '*.pyx'); do
      echo $fn | sed 's/\.\.pyx$/\.c/' | xargs ${cython}/bin/cython -3
    done
  '';

  pythonImportsCheck = [ "GPy" ];

  meta = with lib; {
    description = "Gaussian process framework in Python";
    homepage = "https://sheffieldml.github.io/GPy";
    changelog = "https://github.com/SheffieldML/GPy/releases/tag/v.${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    broken = stdenv.isDarwin; # See inscrutable error message here: https://github.com/NixOS/nixpkgs/pull/107653#issuecomment-751527547
  };
}
