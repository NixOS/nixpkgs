{ lib
, buildPythonPackage
, chardet
, docutils
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, pbr
, pygments
, pytestCheckHook
, pythonOlder
, restructuredtext_lint
, setuptools-scm
, stevedore
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2XqT6PWi78RxOggEZX3trYN0XMpM0diN6Rhvd/l3YAQ=";
  };

<<<<<<< HEAD
  patches = [
    # https://github.com/PyCQA/doc8/pull/146
    (fetchpatch {
      name = "remove-setuptools-scm-git-archive.patch";
      url = "https://github.com/PyCQA/doc8/commit/06416e95041db92e4295b13ab596351618f6b32e.patch";
      hash = "sha256-IIE3cDNOx+6RLjidGrokyazaX7MOVbMKUb7yQIM5sI0=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    wheel
=======
  nativeBuildInputs = [
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    docutils
    chardet
    stevedore
    restructuredtext_lint
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "doc8"
  ];

  meta = with lib; {
    description = "Style checker for Sphinx (or other) RST documentation";
    homepage = "https://github.com/pycqa/doc8";
    changelog = "https://github.com/PyCQA/doc8/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
