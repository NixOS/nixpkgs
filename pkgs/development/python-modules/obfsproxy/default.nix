{
  lib,
  buildPythonPackage,
  fetchgit,
  pyptlib,
  twisted,
  pycrypto,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "obfsproxy";
  version = "0.2.13";
  format = "setuptools";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/obfsproxy.git";
    tag = "${pname}-${version}";
    hash = "sha256-ylkxB0SNkLyXf0XxvwIJMcu6uqXWxCda5hb/jigLShI=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "version=versioneer.get_version()" "version='${version}'"
    substituteInPlace setup.py --replace "argparse" ""
  '';

  propagatedBuildInputs = [
    pyptlib
    twisted
    pycrypto
    pyyaml
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Pluggable transport proxy";
    homepage = "https://www.torproject.org/projects/obfsproxy";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    license = lib.licenses.bsd3;
  };
}
