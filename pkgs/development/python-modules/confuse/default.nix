{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pyyaml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "1.5.0";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kvilxhjifvz6ra64jadf9jiwphrah5rcb9ryq0v7w1dywgn4qp7";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "confuse"
  ];

  meta = with lib; {
    description = "Python configuration library for Python that uses YAML";
    homepage = "https://github.com/beetbox/confuse";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
