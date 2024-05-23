{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lazy-loader";
  version = "0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "scientific-python";
    repo = "lazy_loader";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ky9EwPYt/wBqWXopH5WFjlVG+/Rd2gc+mlCeWqG7mZg=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Populate library namespace without incurring immediate import costs";
    homepage = "https://github.com/scientific-python/lazy_loader";
    changelog = "https://github.com/scientific-python/lazy_loader/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
