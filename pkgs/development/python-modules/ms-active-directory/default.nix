{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  fetchpatch,
  ldap3,
  pyasn1,
  pycryptodome,
  pythonOlder,
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "ms-active-directory";
  version = "1.14.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "zorn96";
    repo = "ms_active_directory";
    rev = "refs/tags/v${version}";
    hash = "sha256-E0GzKkpQU9pJ1a1N0NZjB2Q99yMlJkzNR0QzyiUzOpg=";
  };

  patches = [
    # Fix introduced syntax errors, https://github.com/zorn96/ms_active_directory/pull/88
    (fetchpatch {
      name = "fix-syntax.patch";
      url = "https://github.com/zorn96/ms_active_directory/pull/88/commits/35da06a224b9bff6d36ddbd2dee8fdedab7e17bc.patch";
      hash = "sha256-0WGyr3Q4vcfFU72fox3/3AdHCmjzf6jGCGPx5vhhUvM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    dnspython
    ldap3
    pyasn1
    pycryptodome
    pytz
    six
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ms_active_directory" ];

  meta = with lib; {
    description = "Python module for integrating with Microsoft Active Directory domains";
    homepage = "https://github.com/zorn96/ms_active_directory/";
    changelog = "https://github.com/zorn96/ms_active_directory/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
