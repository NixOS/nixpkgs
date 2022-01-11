{ lib, castxml, fetchFromGitHub, buildPythonPackage,
llvmPackages }:
buildPythonPackage rec {
  pname = "pygccxml";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner  = "gccxml";
    repo   = "pygccxml";
    rev    = "v${version}";
    sha256 = "1msqpg3dqn7wjlf91ddljxzz01a3b1p2sy91n36lrsy87lz499gh";
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
