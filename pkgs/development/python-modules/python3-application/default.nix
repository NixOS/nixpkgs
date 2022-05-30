{ stdenv, lib, isPy3k, buildPythonPackage, fetchFromGitHub, fetchpatch, zope_interface, twisted }:

buildPythonPackage rec {
  pname = "python3-application";
  version = "3.0.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = version;
    sha256 = "sha256-oscUI/Ag/UXmAi/LN1pPTdyqQe9aAfeQzhKFxaTmW3A=";
  };

  patches = [
    # Apply bugfix commit that is not yet part of a release
    (fetchpatch {
      name = "fix-time-import.patch";
      url = "https://github.com/AGProjects/python3-application/commit/695f7d769e69c84e065872ffb403157d0af282fd.patch";
      sha256 = "sha256-MGs8uUIFXkPXStOn5oCNNEMVmcKrq8YPl8Xvl3OTOUM=";
    })
  ];

  propagatedBuildInputs = [ zope_interface twisted ];

  pythonImportsCheck = [ "application" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "A collection of modules that are useful when building python applications";
    homepage = "https://github.com/AGProjects/python3-application";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      This package is a collection of modules that are useful when building python applications. Their purpose is to eliminate the need to divert resources into implementing the small tasks that every application needs to do in order to run successfully and focus instead on the application logic itself.
      The modules that the application package provides are:
        1. process - UNIX process and signal management.
        2. python - python utility classes and functions.
        3. configuration - a simple interface to handle configuration files.
        4. log - an extensible system logger for console and syslog.
        5. debug - memory troubleshooting and execution timing.
        6. system - interaction with the underlying operating system.
        7. notification - an application wide notification system.
        8. version - manage version numbers for applications and packages.
    '';
  };
}
