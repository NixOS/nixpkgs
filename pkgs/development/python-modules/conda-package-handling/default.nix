{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  conda-package-streaming,
}:
buildPythonPackage rec {
  pname = "conda-package-handling";
  version = "2.4.0";
  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-package-handling";
    tag = version;
    hash = "sha256-AvuxHl3gUH7zIyMhZGeXqpMy0rJ99wj1/SrdTvlaX9A=";
  };

  pyproject = true;
  build-system = [ setuptools ];
  dependencies = [ conda-package-streaming ];

  pythonImportsCheck = [ "conda_package_handling" ];

  meta = with lib; {
    description = "Create and extract conda packages of various formats";
    homepage = "https://github.com/conda/conda-package-handling";
    license = licenses.bsd3;
    maintainers = [ maintainers.ericthemagician ];
  };
}
