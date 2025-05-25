{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "migen";
  version = "0.9.2-unstable-2025-05-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "b92717a918c4d274d37f6eaff0c57ad689468173";
    hash = "sha256-JwvxF/xwtQpy/JnG7WXhx0y5k+dHDSwNUcMjgQaegbg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "migen" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = " A Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/migen";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ l-as ];
  };
}
