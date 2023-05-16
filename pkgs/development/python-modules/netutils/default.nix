<<<<<<< HEAD
{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, jinja2
, napalm
=======
{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "netutils";
<<<<<<< HEAD
  version = "1.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ocajE7E4xIatEmv58/9gEpWF2plJdiZXjk6ajD2vTzw=";
=======
    hash = "sha256-hSSHCWi0L/ZfFz0JQ6Al5mjhb2g0DpykLF66uMKMIN8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

<<<<<<< HEAD
  propagatedBuildInputs = [
    napalm
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    jinja2
    pytestCheckHook
    pyyaml
    toml
  ];

  pythonImportsCheck = [
    "netutils"
  ];

  disabledTests = [
    # Tests require network access
    "test_is_fqdn_resolvable"
    "test_fqdn_to_ip"
    "test_tcp_ping"
    # Skip Sphinx test
    "test_sphinx_build"
    # OSError: [Errno 22] Invalid argument
    "test_compare_type5"
    "test_encrypt_type5"
<<<<<<< HEAD
    "test_compare_cisco_type5"
    "test_get_napalm_getters_napalm_installed_default"
    "test_encrypt_cisco_type5"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Library that is a collection of objects for common network automation tasks";
    homepage = "https://github.com/networktocode/netutils";
    changelog = "https://github.com/networktocode/netutils/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin;
  };
}
