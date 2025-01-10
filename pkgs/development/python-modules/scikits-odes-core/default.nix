{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scikits-odes-core";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bmcage";
    repo = "odes";
    tag = "v${version}";
    hash = "sha256-wOdqRzj45piT9P+qA0xXBCnOZ9Xh+Waej2t51mDcilc=";
  };

  sourceRoot = "${src.name}/packages/scikits-odes-core";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "scikits_odes_core" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Core support module for scikits-odes";
    homepage = "https://github.com/bmcage/odes/blob/master/packages/scikits-odes-core";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ idontgetoutmuch ];
  };
}
