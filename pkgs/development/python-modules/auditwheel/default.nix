{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools-scm,
  pyelftools,
  importlib-metadata,
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
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZCLEq2Qh0j41XJHplGkmzVMrn99G8rX/2vGr/p7inmc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ pyelftools ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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

  meta = with lib; {
    changelog = "https://github.com/pypa/auditwheel/blob/${version}/CHANGELOG.md";
    description = "Auditing and relabeling cross-distribution Linux wheels";
    homepage = "https://github.com/pypa/auditwheel";
    license = with licenses; [
      mit # auditwheel and nibabel
      bsd2 # from https://github.com/matthew-brett/delocate
      bsd3 # from https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-projects/pax-utils/lddtree.py
    ];
    mainProgram = "auditwheel";
    maintainers = with maintainers; [ davhau ];
    platforms = platforms.linux;
  };
}
