{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pdm-backend
, pyvcd
, jinja2
, importlib-resources
, importlib-metadata
, git

# for tests
, pytestCheckHook
, symbiyosys
, yices
, yosys
}:

buildPythonPackage rec {
  pname = "amaranth";
  format = "pyproject";
  # python -m setuptools_scm
  version = "0.4.dev197+g${lib.substring 0 7 src.rev}";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth";
    rev = "11d5bb19eb34463918c07dc5e2e0eac7dbf822b0";
    sha256 = "sha256-Ji5oYfF2hKSunAdAQTniv8Ajj6NE/bvW5cvadrGKa+U=";
  };

  nativeBuildInputs = [
    git
    pdm-backend
  ];

  propagatedBuildInputs = [
    jinja2
    pyvcd
  ] ++
    lib.optional (pythonOlder "3.9") importlib-resources ++
    lib.optional (pythonOlder "3.8") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
    symbiyosys
    yices
    yosys
  ];

  pythonImportsCheck = [ "amaranth" ];

  meta = with lib; {
    description = "A modern hardware definition language and toolchain based on Python";
    homepage = "https://amaranth-lang.org/docs/amaranth";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily thoughtpolice ];
  };
}
