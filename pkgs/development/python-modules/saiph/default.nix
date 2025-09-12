{
  lib,
  buildPythonPackage,
  poetry-core,
  fetchFromGitHub,
  pytestCheckHook,
  doubles,
  msgspec,
  numpy,
  pandas,
  pydantic,
  scikit-learn,
  scipy,
  toolz,
}:

buildPythonPackage rec {
  pname = "saiph";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "octopize";
    repo = "saiph";
    tag = "${pname}-v${version}";
    hash = "sha256-8AbV3kjPxjZo28CgahfbdNl9+ESWOfUt8YT+mWwbo5Q=";
  };

  pyproject = true;

  build-system = [ poetry-core ];

  postPatch = ''
    # Remove these constraints
    substituteInPlace pyproject.toml \
      --replace 'numpy = "^1"' 'numpy = ">=1"' \
      --replace 'msgspec = "^0.18.5"' 'msgspec = ">=0.18.5"'
  '';

  propagatedBuildInputs = [
    doubles
    msgspec
    numpy
    pandas
    pydantic
    scikit-learn
    scipy
    toolz
  ];

  # No need for benchmarks
  disabledTests = [ "benchmark_test.py" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "saiph" ];

  meta = with lib; {
    description = "A projection package";
    homepage = "https://github.com/octopize/saiph/tree/main";
    license = licenses.asl20;
    maintainers = with maintainers; [ b-rodrigues ];
  };
}
