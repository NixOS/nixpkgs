{ stdenv, castxml, fetchFromGitHub, buildPythonPackage,
llvmPackages }:
buildPythonPackage rec {
  pname = "pygccxml";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner  = "gccxml";
    repo   = "pygccxml";
    rev    = "v${version}";
    sha256 = "02ip03s0vmp7czzflbvf7qnybibfrd0rzqbc5zfmq3zmpnck3hvm";
  };

  buildInputs = [ castxml llvmPackages.libcxxStdenv];

  # running the suite is hard, needs to generate xml_generator.cfg
  # but the format doesn't accept -isystem directives
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/gccxml/pygccxml;
    description = "Python package for easy C++ declarations navigation";
    license = licenses.boost;
    maintainers = with maintainers; [ teto ];
  };
}
