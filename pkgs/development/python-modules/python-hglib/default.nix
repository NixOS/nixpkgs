{
  lib,
  buildPythonPackage,
  fetchhg,
  mercurial,
}:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.6.2-unstable-2024-06-17";
  format = "setuptools";

  src = fetchhg {
    url = "https://repo.mercurial-scm.org/python-hglib";
    rev = "484b56ac4aec";
    hash = "sha256-cksteuqNgr/oeY5t+4IPHcaGX8wXxLWDHyYnmzSx3Uc=";
  };

  # setup.py requires a valid versioning in the sense of Python specifications.
  # https://packaging.python.org/en/latest/specifications/version-specifiers/
  # Remove this when version >2.6.2 released.
  postUnpack = ''
    echo "tag: ${lib.concatStrings (lib.strings.intersperse "." (lib.take 3 (lib.versions.splitVersion version)))}+nixpkgs.1" > hg-archive/.hg_archival.txt
  '';

  nativeCheckInputs = [
    mercurial
  ];

  preCheck = ''
    export HGTMP=$(mktemp -d)
    export HGUSER=test
  '';

  pythonImportsCheck = [ "hglib" ];

  meta = with lib; {
    description = "Library with a fast, convenient interface to Mercurial. It uses Mercurial’s command server for communication with hg";
    homepage = "https://www.mercurial-scm.org/wiki/PythonHglibs";
    license = licenses.mit;
    maintainers = [ ];
  };
}
