{
  lib,
  apt,
  buildPythonPackage,
  fetchgit,
  setuptools,
}:

buildPythonPackage rec {
  pname = "apt";
  version = "2.7.6";

  pyproject = true;

  src = fetchgit {
    url = "https://git.launchpad.net/python-apt";
    rev = "refs/tags/${version}";
    hash = "sha256-1jTe8ncMKV78+cfSZ6p6qdjxs0plZLB4VwVtPLtDlAc=";
  };

  buildInputs = [ apt.dev ];

  nativeBuildInputs = [ setuptools ];

  # Ensure the version is set properly without trying to invoke
  # dpkg-parsechangelog
  env.DEBVER = "${version}";

  pythonImportsCheck = [ "apt_pkg" ];

  meta = {
    description = "Python bindings for APT";
    homepage = "https://launchpad.net/python-apt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
