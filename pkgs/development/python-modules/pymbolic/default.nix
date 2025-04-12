{
  lib,
  astunparse,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  immutabledict,
  matchpy,
  numpy,
  pytestCheckHook,
  pythonOlder,
  pytools,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pymbolic";
  version = "2022.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Cd2lCuzy3Iyn6Hxqito7AnyN9uReMlc/ckqaup87Ik=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/inducer/pymbolic/commit/cb3d999e4788dad3edf053387b6064adf8b08e19.patch";
      excludes = [ ".github/workflows/ci.yml" ];
      hash = "sha256-P0YjqAo0z0LZMIUTeokwMkfP8vxBXi3TcV4BSFaO1lU=";
    })
  ];

  postPatch = ''
    # pytest is a test requirement not a run-time one
      substituteInPlace setup.py \
        --replace '"pytest>=2.3",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    astunparse
    immutabledict
    pytools
    typing-extensions
  ];

  optional-dependencies = {
    matchpy = [ matchpy ];
    numpy = [ numpy ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "pymbolic" ];

  meta = with lib; {
    description = "Package for symbolic computation";
    homepage = "https://documen.tician.de/pymbolic/";
    changelog = "https://github.com/inducer/pymbolic/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
