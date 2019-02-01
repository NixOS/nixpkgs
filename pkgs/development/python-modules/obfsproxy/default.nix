{ stdenv
, buildPythonPackage
, fetchgit
, pyptlib
, twisted
, pycrypto
, pyyaml
}:

buildPythonPackage rec {
  pname = "obfsproxy";
  version = "0.2.13";

  src = fetchgit {
    url = meta.repositories.git;
    rev = "refs/tags/${pname}-${version}";
    sha256 = "04ja1cl8xzqnwrd2gi6nlnxbmjri141bzwa5gybvr44d8h3k2nfa";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "version=versioneer.get_version()" "version='${version}'"
    substituteInPlace setup.py --replace "argparse" ""
  '';

  propagatedBuildInputs = [ pyptlib twisted pycrypto pyyaml ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A pluggable transport proxy";
    homepage = https://www.torproject.org/projects/obfsproxy;
    repositories.git = https://git.torproject.org/pluggable-transports/obfsproxy.git;
    maintainers = with maintainers; [ phreedom thoughtpolice ];
  };

}
