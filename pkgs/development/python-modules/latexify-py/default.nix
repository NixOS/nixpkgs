{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, dill
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "latexify-py";
  version = "0.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "google";
    repo = "latexify_py";
    rev = "refs/tags/v${version}";
    hash = "sha256-b0/cKMfIONVd6A5AYRyLx/qsFVpUjeAsadQyu/mPYxo=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ dill ];

  preCheck = ''
    cd src
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "latexify" ];

  meta = with lib; {
    description = "Generates LaTeX math description from Python functions";
    homepage = "https://github.com/google/latexify_py";
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
  };
}
