{
  lib,
  apt,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-apt";
  version = "3.1.0";

  pyproject = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "apt-team";
    repo = "python-apt";
    tag = finalAttrs.version;
    hash = "sha256-ISvPBBvo6PGYsGS/tKsBEOAEviuFRj5rgydJ5BQ1f+4=";
  };

  buildInputs = [ apt.dev ];

  build-system = [ setuptools ];

  # Ensure the version is set properly without trying to invoke
  # dpkg-parsechangelog
  env.DEBVER = finalAttrs.version;

  pythonImportsCheck = [ "apt_pkg" ];

  meta = {
    changelog = "https://salsa.debian.org/apt-team/python-apt/-/blob/${finalAttrs.version}/debian/changelog";
    description = "Python bindings for APT";
    homepage = "https://launchpad.net/python-apt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      adhityaravi
      bepri
      dstathis
    ];
    platforms = lib.platforms.linux;
  };
})
