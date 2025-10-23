{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitiles,
  setuptools,
  six,
  python,
}:

buildPythonPackage {
  pname = "gyp";
  version = "unstable-2024-02-07";
  pyproject = true;

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/external/gyp";
    rev = "1615ec326858f8c2bd8f30b3a86ea71830409ce4";
    hash = "sha256-E+JF4uJBRka6vtjxyoMGE4IT5kSrl7Vs6WNkMQ+vNgs=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./no-darwin-cflags.patch
    ./no-xcode.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [
    "gyp"
    "gyp.generator"
  ];

  # Make mac_tool.py executable so that patchShebangs hook processes it. This
  # file is copied and run by builds using gyp on macOS
  preFixup = ''
    chmod +x "$out/${python.sitePackages}/gyp/mac_tool.py"
  '';

  meta = with lib; {
    description = "Tool to generate native build files";
    mainProgram = "gyp";
    homepage = "https://gyp.gsrc.io";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
