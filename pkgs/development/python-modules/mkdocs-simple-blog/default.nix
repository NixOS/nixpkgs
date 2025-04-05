{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  mkdocs,
  pytestCheckHook,
  mock,
  pillow,
  ase,
}:
buildPythonPackage rec {
  pname = "mkdocs-simple-blog";
  version = "0.1.0"; # Update this with the correct version from the project
  pyproject = false;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "FernandoCelmer";
    repo = pname;
    rev = "6a9971496ca8b7f53d0c78fe7859ca266583f866"; # Update with the exact commit hash/tag
    hash = "sha256-opl+8BRejr/cs3TrhFMZK9Xbq96kEQ6qVhI3EKDn858="; # Update with correct hash
  };

  propagatedBuildInputs = [
    mkdocs
    # Add other required dependencies here
    # (check setup.py or requirements.txt in the repo)
  ];

  # Add any test dependencies if needed
  nativeCheckInputs = [
    ase
    mock
    pillow
    pytestCheckHook
  ];

  # Disable tests if they're not included or need special setup
  doCheck = true;

  pythonImportsCheck = [ "mkdocs_simple_blog" ];

  meta = {
    description = "A simple blog generator plugin for MkDocs";
    homepage = "https://github.com/FernandoCelmer/mkdocs-simple-blog";
    license = lib.licenses.mit; # Verify the correct license from the project
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
