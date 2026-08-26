{
  lib,
  buildPythonPackage,
  fetchPypi,
  jsonschema,
  packaging,
  pretend,
  pyelftools,
  pytestCheckHook,
  setuptools-scm,
  # non-python dependencies
  bzip2,
  gnutar,
  patchelf,
  unzip,
}:

buildPythonPackage rec {
  pname = "auditwheel";
  version = "6.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Egw0X1v8yf2GrhEPHZ0mZl3b8d78pwDuS5JTaqp9BjY=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    packaging
    pyelftools
  ];

  nativeCheckInputs = [
    jsonschema
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

  meta = {
    changelog = "https://github.com/pypa/auditwheel/blob/${version}/CHANGELOG.md";
    description = "Auditing and relabeling cross-distribution Linux wheels";
    homepage = "https://github.com/pypa/auditwheel";
    license = with lib.licenses; [
      mit # auditwheel and nibabel
      bsd2 # from https://github.com/matthew-brett/delocate
      bsd3 # from https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-projects/pax-utils/lddtree.py
    ];
    mainProgram = "auditwheel";
    maintainers = with lib.maintainers; [ davhau ];
    platforms = lib.platforms.linux;
  };
}
