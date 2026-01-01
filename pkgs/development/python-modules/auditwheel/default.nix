{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchPypi,
  setuptools-scm,
  pyelftools,
  packaging,
  pretend,
  pytestCheckHook,
  # non-python dependencies
  bzip2,
  gnutar,
  patchelf,
  unzip,
}:

buildPythonPackage rec {
  pname = "auditwheel";
<<<<<<< HEAD
  version = "6.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T7y9WFQFS7HdeHDbA3J7hxuWsYFH21cllWHAWGA5h9c=";
=======
  version = "6.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t6Ya/JGDtrXGYd5ZylhvnHIARFpAnFjN8gSdb3FjbVE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    packaging
    pyelftools
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  # Integration tests require docker and networking
  disabledTestPaths = [ "tests/integration" ];

  # Ensure that there are no undeclared deps
  postCheck = ''
    PATH= PYTHONPATH= $out/bin/auditwheel --version > /dev/null
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      bzip2
      gnutar
      patchelf
      unzip
    ])
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/pypa/auditwheel/blob/${version}/CHANGELOG.md";
    description = "Auditing and relabeling cross-distribution Linux wheels";
    homepage = "https://github.com/pypa/auditwheel";
    license = with lib.licenses; [
=======
  meta = with lib; {
    changelog = "https://github.com/pypa/auditwheel/blob/${version}/CHANGELOG.md";
    description = "Auditing and relabeling cross-distribution Linux wheels";
    homepage = "https://github.com/pypa/auditwheel";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit # auditwheel and nibabel
      bsd2 # from https://github.com/matthew-brett/delocate
      bsd3 # from https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-projects/pax-utils/lddtree.py
    ];
    mainProgram = "auditwheel";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ davhau ];
    platforms = lib.platforms.linux;
=======
    maintainers = with maintainers; [ davhau ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
