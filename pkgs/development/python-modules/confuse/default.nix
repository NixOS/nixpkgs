{ buildPythonPackage
, enum34
, fetchFromGitHub
, flit-core
, isPy27
, lib
, pathlib
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "1.5.0";
  format = "flit";

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
  ] ++ lib.optionals isPy27 [
    enum34
    pathlib
  ] ;

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "confuse" ];

  meta = with lib; {
    description = "Python configuration library for Python that uses YAML";
    homepage = "https://github.com/beetbox/confuse";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
