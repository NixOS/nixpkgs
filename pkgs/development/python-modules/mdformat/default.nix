{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  markdown-it-py,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mdformat";
  version = "0.7.22";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat";
    tag = version;
    hash = "sha256-WvbGCqfzh7KlNXIGJq09goiyLzVgU7c1+qmsLrIW38k=";
  };

  build-system = [ setuptools ];

  dependencies = [ markdown-it-py ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat" ];

  passthru = {
    withPlugins = throw "Use pkgs.mdformat.withPlugins, i.e. the top-level attribute.";
  };

<<<<<<< HEAD
  meta = {
    description = "CommonMark compliant Markdown formatter";
    homepage = "https://mdformat.rtfd.io/";
    changelog = "https://github.com/executablebooks/mdformat/blob/${version}/docs/users/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "CommonMark compliant Markdown formatter";
    homepage = "https://mdformat.rtfd.io/";
    changelog = "https://github.com/executablebooks/mdformat/blob/${version}/docs/users/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fab
      aldoborrero
    ];
    mainProgram = "mdformat";
  };
}
