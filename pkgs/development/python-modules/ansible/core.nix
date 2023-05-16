{ lib
<<<<<<< HEAD
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, installShellFiles
, ansible
, cryptography
, importlib-resources
=======
, callPackage
, buildPythonPackage
, fetchPypi
, installShellFiles
, ansible
, cryptography
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, jinja2
, junit-xml
, lxml
, ncclient
, packaging
, paramiko
<<<<<<< HEAD
, ansible-pylibssh
, passlib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pexpect
, psutil
, pycrypto
, pyyaml
, requests
, resolvelib
, scp
, windowsSupport ? false, pywinrm
, xmltodict
}:

buildPythonPackage rec {
  pname = "ansible-core";
<<<<<<< HEAD
  version = "2.15.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-waiq7emF955ZMrohY2OTeffYAlv9myg3jbFkmk71Qe0=";
=======
  version = "2.14.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R/DUtBJbWO26ZDWkfzfL5qGNpUWU0Y+BKVi7DLWNTmU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # ansible_connection is already wrapped, so don't pass it through
  # the python interpreter again, as it would break execution of
  # connection plugins.
  postPatch = ''
    substituteInPlace lib/ansible/executor/task_executor.py \
      --replace "[python," "["
  '';

  nativeBuildInputs = [
    installShellFiles
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.10") [
    pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    # depend on ansible instead of the other way around
    ansible
    # from requirements.txt
    cryptography
    jinja2
    packaging
<<<<<<< HEAD
    passlib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pyyaml
    resolvelib # This library is a PITA, since ansible requires a very old version of it
    # optional dependencies
    junit-xml
    lxml
    ncclient
    paramiko
<<<<<<< HEAD
    ansible-pylibssh
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pexpect
    psutil
    pycrypto
    requests
    scp
    xmltodict
<<<<<<< HEAD
  ] ++ lib.optionals windowsSupport [
    pywinrm
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-resources
  ];

  pythonRelaxDeps = lib.optionals (pythonOlder "3.10") [
    "importlib-resources"
  ];
=======
  ] ++ lib.optional windowsSupport pywinrm;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    installManPage docs/man/man1/*.1
  '';

  # internal import errors, missing dependencies
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/ansible/ansible/blob/v${version}/changelogs/CHANGELOG-v${lib.versions.majorMinor version}.rst";
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
