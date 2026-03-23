{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  python-dateutil,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bson";
  version = "0.5.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "py-bson";
    repo = "bson";
    tag = version;
    hash = "sha256-mirRpo27RoOBlwxVOKnHaDIzJOErp7c2VxCOunUm/u4=";
  };

  patches = [
    # Upstream PR: https://github.com/py-bson/bson/pull/113
    (fetchpatch {
      name = "python-3.11.patch";
      url = "https://github.com/py-bson/bson/commit/5346e73124de8a1f9e2a1960501416529e4cee02.patch";
      hash = "sha256-kNs00j/FDjb2av+0WMORrCo75NcuaJXUl4SbYlksnfo=";
    })
    # Upstream PR: https://github.com/py-bson/bson/pull/140
    (fetchpatch {
      name = "python-3.14.patch";
      url = "https://github.com/py-bson/bson/commit/4e6b4c206f7204034ef74bff8ae84a95d76d1684.patch";
      includes = [ "setup.py" ];
      hash = "sha256-JOmW/KMqzFdXKH4TMR/PG1YU3SvLTBc3L3E9kXag3bQ=";
    })
  ];

  propagatedBuildInputs = [
    python-dateutil
    six
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bson" ];

  meta = {
    description = "BSON codec for Python";
    homepage = "https://github.com/py-bson/bson";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
