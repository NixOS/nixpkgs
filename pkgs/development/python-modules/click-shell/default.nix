{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  pytestCheckHook,
  pytest-click,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "click-shell";
  version = "2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clarkperkins";
    repo = "click-shell";
    tag = version;
    hash = "sha256-4QpQzg0yFuOFymGiTI+A8o6LyX78iTJMqr0ernYbilI=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  nativeCheckInputs = [
    pytest-click
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "click_shell" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Extension to click that easily turns your click app into a shell utility";
    longDescription = ''
      This is an extension to click that easily turns your click app into a
      shell utility. It is built on top of the built in python cmd module,
      with modifications to make it work with click. It adds a 'shell' mode
      with command completion to any click app.
    '';
    homepage = "https://github.com/clarkperkins/click-shell";
    changelog = "https://github.com/clarkperkins/click-shell/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ binsky ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ binsky ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
