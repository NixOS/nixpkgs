{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  pytestCheckHook,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "airium";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "kamichal";
    repo = "airium";
    rev = "v${version}";
    hash = "sha256-qAU+rmj2ZHw7KdxVvRyponcPiRcyENfDyW1y9JTiwsY=";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
  ];

  # tests require internet access, broken in sandbox
  disabledTests = [
    "test_get_bad_content_type"
    "test_translate_remote_file"
  ];

  meta = with lib; {
    description = "Bidirectional HTML-python translator";
    mainProgram = "airium";
    homepage = "https://gitlab.com/kamichal/airium";
    license = licenses.mit;
    maintainers = with maintainers; [ hulr ];
  };
}
