{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  deterministic-uname,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zxpy";
  version = "1.6.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tusharsadhwani";
    repo = "zxpy";
    rev = version;
    hash = "sha256-/sOLSIqaAUkaAghPqe0Zoq7C8CSKAd61o8ivtjJFcJY=";
  };

  patches = [
    # fix test caused by `uname -p` printing unknown
    # https://github.com/tusharsadhwani/zxpy/pull/53
    (fetchpatch {
      name = "allow-unknown-processor-in-injection-test.patch";
      url = "https://github.com/tusharsadhwani/zxpy/commit/95ad80caddbab82346f60ad80a601258fd1238c9.patch";
      hash = "sha256-iXasOKjWuxNjjTpb0umNMNhbFgBjsu5LsOpTaXllATM=";
    })
  ];

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  nativeCheckInputs = [
    deterministic-uname
    python3.pkgs.pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "zx" ];

  meta = with lib; {
    description = "Shell scripts made simple";
    homepage = "https://github.com/tusharsadhwani/zxpy";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "zxpy";
  };
}
