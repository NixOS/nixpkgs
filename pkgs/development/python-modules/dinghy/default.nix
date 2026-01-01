{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  aiofiles,
  aiohttp,
  backports-datetime-fromisoformat,
  click,
  click-log,
  emoji,
  glom,
  jinja2,
  pyyaml,
  freezegun,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dinghy";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = "dinghy";
    tag = version;
    hash = "sha256-51BXQdDxlI6+3ctDSa/6tyRXBb1E9BVej9qy7WtkOGM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    backports-datetime-fromisoformat
    click
    click-log
    emoji
    glom
    jinja2
    pyyaml
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dinghy.cli" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "GitHub activity digest tool";
    mainProgram = "dinghy";
    homepage = "https://github.com/nedbat/dinghy";
    changelog = "https://github.com/nedbat/dinghy/blob/${src.tag}/CHANGELOG.rst";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      trundle
      veehaitch
    ];
  };
}
