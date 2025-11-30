{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  cython,
  setuptools,
  wheel,
  numpy,
}:
buildPythonPackage rec {
  pname = "daqp";
  version = "0.7.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    tag = "v${version}";
    hash = "sha256-I+ObnFAAhRoYtPEDXGP6BI+Zk9CH5yU27JJ+tWbcACQ=";
  };

  sourceRoot = "${src.name}/interfaces/daqp-python";

  postPatch = ''
    sed -i 's|../../../daqp|../..|' setup.py
    sed -i 's|if src_path and os.path.exists(src_path):|if False:|' setup.py
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "test"
    "-p"
    "'*.py'"
    "-v"
  ];

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "daqp" ];

  meta = with lib; {
    description = "Dual active-set algorithm for convex quadratic programming";
    homepage = "https://github.com/darnstrom/daqp";
    license = licenses.mit;
    maintainers = with maintainers; [ renesat ];
  };
}
