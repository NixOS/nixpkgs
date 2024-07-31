{
  lib,
  apt,
  buildPythonPackage,
  fetchFromGitLab,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "apt";
  version = "2.8.0";

  pyproject = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "apt-team";
    repo = "python-apt";
    rev = "refs/tags/${version}";
    hash = "sha256-7l7rgyJ28iQuL6ShF/KYwL/kAXpLPTqnUIavVxNF+wU=";
  };

  buildInputs = [ apt.dev ];

  build-system = [ setuptools ];

  # Ensure the version is set properly without trying to invoke
  # dpkg-parsechangelog
  env.DEBVER = version;

  pythonImportsCheck = [ "apt_pkg" ];

  meta = {
    changelog = "https://salsa.debian.org/apt-team/python-apt/-/blob/${version}/debian/changelog";
    description = "Python bindings for APT";
    homepage = "https://launchpad.net/python-apt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
