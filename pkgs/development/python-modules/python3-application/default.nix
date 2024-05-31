{
  stdenv,
  lib,
  isPy3k,
  buildPythonPackage,
  fetchFromGitHub,
  zope-interface,
  twisted,
}:

buildPythonPackage rec {
  pname = "python3-application";
  version = "3.0.6";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = "release-${version}";
    hash = "sha256-L7KN6rKkbjNmkSoy8vdMYpXSBkWN7afNpreJO0twjq8=";
  };

  propagatedBuildInputs = [
    zope-interface
    twisted
  ];

  pythonImportsCheck = [ "application" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A collection of modules that are useful when building python applications";
    homepage = "https://github.com/AGProjects/python3-application";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      chanley
      yureien
    ];
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
