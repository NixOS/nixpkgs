{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, matchpy
, pytestCheckHook
, pythonOlder
, pytools
}:

buildPythonPackage rec {
  pname = "pymbolic";
  version = "2022.2";
  format = "setuptools";

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

  propagatedBuildInputs = [
    pytools
  ];

  nativeCheckInputs = [
    matchpy
    pytestCheckHook
  ];

  postPatch = ''
    # pytest is a test requirement not a run-time one
      substituteInPlace setup.py \
        --replace '"pytest>=2.3",' ""
  '';

  pythonImportsCheck = [
    "pymbolic"
  ];

  meta = with lib; {
    description = "A package for symbolic computation";
    homepage = "https://documen.tician.de/pymbolic/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
