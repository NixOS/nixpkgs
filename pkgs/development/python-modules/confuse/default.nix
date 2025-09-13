{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pyyaml,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "confuse";
    rev = "v${version}";
    hash = "sha256-TVx0cBXv/fIuli/xrFXBAmwJ1rQr5xJL1Q67FaDr4ow=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "confuse" ];

  meta = with lib; {
    description = "Python configuration library for Python that uses YAML";
    homepage = "https://github.com/beetbox/confuse";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
