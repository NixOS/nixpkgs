{ lib
, buildPythonPackage
, fetchFromGitHub
, cffi
, six
, pytestCheckHook
, pytest-mock
, R
, rPackages }:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.3.40";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "v${version}";
    sha256 = "yJMiPmusZ62dd6+5VkA2uSjq57a0C3arG8CgiUUHKpk=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
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
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
