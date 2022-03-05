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
  version = "1.7.0";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zdH5DNXnuAfYTuaG9EIKiXL2EbLSfzYjPSkC3G06bU8=";
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
