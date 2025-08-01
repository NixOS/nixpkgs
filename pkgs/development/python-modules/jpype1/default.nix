{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ant,
  openjdk,
  packaging,
  pyinstaller,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jpype1";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "originell";
    repo = "jpype";
    tag = "v${version}";
    hash = "sha256-CDiVQugxLgmUwAG0e0ryamWvrjUaJxJrU0YSFIIWS1I=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    ant
    openjdk
  ];

  preBuild = ''
    ant -f native/build.xml jar
  '';

  dependencies = [ packaging ];

  nativeCheckInputs = [
    pyinstaller
    pytestCheckHook
  ];

  # Cannot find various classes. If you want to fix this
  # take a look at the opensuse packaging:
  # https://build.opensuse.org/projects/openSUSE:Factory/packages/python-JPype1/files/python-JPype1.spec?expand=1
  doCheck = false;

  preCheck = ''
    ant -f test/build.xml compile
  '';

  pythonImportsCheck = [
    "jpype"
    "jpype.imports"
    "jpype.types"
  ];

  meta = with lib; {
    homepage = "https://github.com/originell/jpype/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    description = "Python to Java bridge";
  };
}
