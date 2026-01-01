{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  impacket,
  ldap3-bleeding-edge,
  lxml,
  pyasn1,
  pycryptodome,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pywerview";
<<<<<<< HEAD
  version = "0.7.5";
  pyproject = true;

=======
  version = "0.7.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "the-useless-one";
    repo = "pywerview";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wl7/u9Uja/FflO3tN3UyanX2LIRG417RfWdyZCtUtGs=";
=======
    hash = "sha256-ZIv0IW7oruMBwinXvH/n1YEtbBFyLb8h/Qlh4JxvV4k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    impacket
    ldap3-bleeding-edge
    lxml
    pycryptodome
    pyasn1
  ];

  optional-dependencies = {
    kerberos = [ ldap3-bleeding-edge ] ++ ldap3-bleeding-edge.optional-dependencies.kerberos;
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pywerview" ];

<<<<<<< HEAD
  meta = {
    description = "Module for PowerSploit's PowerView support";
    homepage = "https://github.com/the-useless-one/pywerview";
    changelog = "https://github.com/the-useless-one/pywerview/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for PowerSploit's PowerView support";
    homepage = "https://github.com/the-useless-one/pywerview";
    changelog = "https://github.com/the-useless-one/pywerview/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pywerview";
  };
}
