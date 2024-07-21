{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  jinja2,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "jinja2-git";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "jinja2-git";
    rev = "refs/tags/${version}";
    hash = "sha256-XuN2L3/HLcZ/WPWiCtufDOmkxj+q4I6IOgjrGQHfNLk=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ jinja2 ];

  # the tests need to be run on the git repository
  doCheck = false;

  pythonImportsCheck = [ "jinja2_git" ];

  meta = with lib; {
    homepage = "https://github.com/wemake-services/jinja2-git";
    description = "Jinja2 extension to handle git-specific things";
    changelog = "https://github.com/wemake-services/jinja2-git/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
