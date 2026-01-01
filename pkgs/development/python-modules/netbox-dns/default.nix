{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
}:
buildPythonPackage rec {
  pname = "netbox-plugin-dns";
<<<<<<< HEAD
  version = "1.4.4";
=======
  version = "1.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peteeckel";
    repo = "netbox-plugin-dns";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-166DFPSF1f0YF0T2bTEkmyI4M6PgBfimYyZX7fnNfrI=";
=======
    hash = "sha256-vJZP4dQdOZQNT+3xRXX2H5gl6bv2z2PvGDkkme0Rbck=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
  ];

  # pythonImportsCheck fails due to improperly configured django app

  meta = {
    description = "Netbox plugin for managing DNS data";
    homepage = "https://github.com/peteeckel/netbox-plugin-dns";
    changelog = "https://github.com/peteeckel/netbox-plugin-dns/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    teams = with lib.teams; [ secshell ];
=======
    maintainers = with lib.maintainers; [ felbinger ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
