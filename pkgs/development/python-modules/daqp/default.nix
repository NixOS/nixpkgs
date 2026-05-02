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
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    tag = "v${version}";
    hash = "sha256-bjHu3hXMuqi4rzN2KnOnfKUWvdsoWZgB/13+Yac4Mw8=";
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

  meta = {
    description = "Dual active-set algorithm for convex quadratic programming";
    homepage = "https://github.com/darnstrom/daqp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renesat ];
  };
}
