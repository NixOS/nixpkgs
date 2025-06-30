{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  poetry-core,
  poetry-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "interface-meta";
  version = "1.3.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matthewwardrop";
    repo = "interface_meta";
    rev = "v${version}";
    sha256 = "0rzh11wnab33b11391vc2ynf8ncxn22b12wn46lmgkrc5mqza8hd";
  };

  patches = [ ./0001-fix-version.patch ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ poetry-dynamic-versioning ];

  pythonImportsCheck = [ "interface_meta" ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/matthewwardrop/interface_meta";
    description = "Convenient way to expose an extensible API with enforced method signatures and consistent documentation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
