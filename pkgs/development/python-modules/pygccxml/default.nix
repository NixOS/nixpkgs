{ lib, castxml, fetchFromGitHub, buildPythonPackage,
llvmPackages }:
buildPythonPackage rec {
  pname = "pygccxml";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner  = "gccxml";
    repo   = "pygccxml";
    rev    = "v${version}";
    sha256 = "1vsxnfzz6qhiv8ac98qgk6w3s4j1jp661qy48gc9plcg2r952453";
  };

  buildInputs = [ castxml llvmPackages.libcxxStdenv];

  # running the suite is hard, needs to generate xml_generator.cfg
  # but the format doesn't accept -isystem directives
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gccxml/pygccxml";
    description = "Python package for easy C++ declarations navigation";
    license = licenses.boost;
    maintainers = with maintainers; [ teto ];
  };
}
