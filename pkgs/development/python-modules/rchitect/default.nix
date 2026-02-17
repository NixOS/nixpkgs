{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  packaging,
  pytestCheckHook,
  pytest-mock,
  R,
  rPackages,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = "rchitect";
    tag = "v${version}";
    hash = "sha256-xIBDPYuEdYrwpHQBSXfZcEkLra+b0bKy5ILNDCS2Vz0=";
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

  meta = {
    description = "Interoperate R with Python";
    homepage = "https://github.com/randy3k/rchitect";
    changelog = "https://github.com/randy3k/rchitect/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
  };
}
