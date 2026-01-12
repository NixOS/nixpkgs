{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
}:

buildPythonPackage rec {
  pname = "buildstream-plugins";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream-plugins";
    tag = version;
    hash = "sha256-nWs18iYXRcEIWVvIC3pnbhczK7Fxf2Jqk4GT7Dv0EXs=";
  };

  build-system = [
    cython
    setuptools
  ];

  # Do not run pyTest, causes infinite recursion as `buildstream-plugins`
  # depends on `Buildstream`, and vice-versa for tests.
  # May be fixable by skipping certain tests? TODO.

  pythonImportsCheck = [ "buildstream_plugins" ];

  meta = {
    description = "BuildStream plugins";
    homepage = "https://github.com/apache/buildstream-plugins";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
}
