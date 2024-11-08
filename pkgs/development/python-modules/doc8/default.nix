{
  lib,
  buildPythonPackage,
  chardet,
  docutils,
  fetchpatch,
  fetchPypi,
  pbr,
  pygments,
  pytestCheckHook,
  pythonOlder,
  restructuredtext-lint,
  setuptools-scm,
  stevedore,
  wheel,
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "1.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EiXzAUThzJfjiNuvf+PpltKJdHOlOm2uJo3d4hw1S5g=";
  };

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
  ];

  buildInputs = [ pbr ];

  propagatedBuildInputs = [
    docutils
    chardet
    stevedore
    restructuredtext-lint
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [ "docutils" ];

  pythonImportsCheck = [ "doc8" ];

  meta = with lib; {
    description = "Style checker for Sphinx (or other) RST documentation";
    mainProgram = "doc8";
    homepage = "https://github.com/pycqa/doc8";
    changelog = "https://github.com/PyCQA/doc8/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
