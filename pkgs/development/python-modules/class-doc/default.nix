{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "class-doc";
  version = "1.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danields761";
    repo = "class-doc";
    tag = version; # no 0.2.6 version tag
    hash = "sha256-uHbXzgAFpsr4o7kq+wgZ3l+alAUG6iCUqenonuibiUw=";
  };

  patches = [
    # https://github.com/danields761/class-doc/pull/2
    (fetchpatch {
      name = "poetry-to-poetry-core.patch";
      url = "https://github.com/danields761/class-doc/commit/03b224ad0a6190c30e4932fa2ccd4a7f0c5c4b5d.patch";
      hash = "sha256-shWPRaZkvtJ1Ae17aCOm6eLs905jxwq84SWOrChEs7M=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ more-itertools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "class_doc" ];

  meta = {
    description = "Extract attributes docstrings defined in various ways";
    homepage = "https://github.com/danields761/class-doc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
