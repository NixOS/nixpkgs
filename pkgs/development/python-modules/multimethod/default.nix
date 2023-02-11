{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "multimethod";
  version = "1.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coady";
    repo = pname;
    rev = "v${version}";
    sha256 = "09vrxzv8q0lqsbh6d83wjdd29ja66rj31y7wmyha14jk603fd9k0";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "multimethod"
  ];

  meta = with lib; {
    description = "Multiple argument dispatching";
    homepage = "https://github.com/coady/multimethod";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
