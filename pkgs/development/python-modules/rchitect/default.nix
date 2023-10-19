{ lib
, buildPythonPackage
, fetchFromGitHub
, cffi
, pytestCheckHook
, pytest-mock
, pythonOlder
, R
, rPackages
, six
}:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-e0xCUp5WBP4UKPkwPfrouNNYTBEnhlHHlkBQmghQfdk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  propagatedBuildInputs = [
    cffi
    six
  ] ++ (with rPackages; [
    reticulate
  ]);

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
