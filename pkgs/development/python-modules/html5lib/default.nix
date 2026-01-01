{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  setuptools,
  six,
  webencodings,
  pytest-expect,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "html5lib";
  version = "1.1-unstable-2024-02-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "html5lib";
    repo = "html5lib-python";
    rev = "fd4f032bc090d44fb11a84b352dad7cbee0a4745";
    hash = "sha256-Hyte1MEqlrD2enfunK1qtm3FJlUDqmhSyrCjo7VaBgA=";
  };

  patches = [
    # https://github.com/html5lib/html5lib-python/pull/583
    ./python314-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
=======
  fetchPypi,
  fetchpatch,
  six,
  webencodings,
  mock,
  pytest-expect,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "html5lib";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f";
  };

  patches = [
    # Fix compatibility with pytest 6.
    # Will be included in the next release after 1.1.
    (fetchpatch {
      url = "https://github.com/html5lib/html5lib-python/commit/2c19b9899ab3a3e8bd0ca35e5d78544334204169.patch";
      hash = "sha256-VGCeB6o2QO/skeCZs8XLPfgEYVOSRL8cCpG7ajbZWEs=";
    })
  ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    six
    webencodings
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
=======
  # latest release not compatible with pytest 6
  doCheck = false;
  nativeCheckInputs = [
    mock
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytest-expect
    pytestCheckHook
  ];

<<<<<<< HEAD
  passthru.updateScript = unstableGitUpdater {
    branch = "master";
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    homepage = "https://github.com/html5lib/html5lib-python";
    downloadPage = "https://github.com/html5lib/html5lib-python/releases";
    description = "HTML parser based on WHAT-WG HTML5 specification";
    longDescription = ''
      html5lib is a pure-python library for parsing HTML. It is designed to
      conform to the WHATWG HTML specification, as is implemented by all
      major web browsers.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prikhi
    ];
  };
}
