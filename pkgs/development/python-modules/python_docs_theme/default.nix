{ lib, buildPythonPackage, fetchFromGitHub, flit-core, sphinx }:

buildPythonPackage rec {
  pname = "python_docs_theme";
  version = "2023.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    rev = "refs/tags/${version}";
    sha256 = "sha256-XVwMEfprTNdNnaW38HMCAu4CswdVjBXYtNWBgqXfbno=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "python_docs_theme" ];

  meta = with lib; {
    homepage = "https://github.com/python/python-docs-theme";
    description = "Sphinx theme for CPython project";
    license = licenses.psfl;
    maintainers = with maintainers; [ kaction ];
  };
}
