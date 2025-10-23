{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  packaging,
  pytestCheckHook,
  pytest-mock,
  pythonOlder,
  R,
  rPackages,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.4.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = "rchitect";
    tag = "v${version}";
    hash = "sha256-R1Zr0M6NQw+8MYHSm8ll5oe/P1Q/apO4xnWdWVFTgWQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cffi
    six
    packaging
  ]
  ++ (with rPackages; [ reticulate ]);

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    R
  ];

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
    cd $TMPDIR
  '';

  pythonImportsCheck = [ "rchitect" ];

  meta = with lib; {
    description = "Interoperate R with Python";
    homepage = "https://github.com/randy3k/rchitect";
    changelog = "https://github.com/randy3k/rchitect/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
