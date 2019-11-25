{ stdenv, buildDunePackage, fetchFromGitHub, m4, core_kernel, ounit }:

buildDunePackage rec {
  pname = "cfstream";
  version = "1.3.0";

  owner = "biocaml";

  minimumSupportedOcamlVersion = "4.04.1";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = version;
    sha256 = "1bpzpci0cx6r3sdk183mm603wgzvvj46nlx0lpx44108anxcxbak";
  };

  patches = [ ./git_commit.patch ];

  buildInputs = [ m4 ];
  checkInputs = [ ounit ];
  propagatedBuildInputs = [ core_kernel ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Simple Core-inspired wrapper for standard library Stream module";
    homepage = "http://github.com/${owner}/${pname}";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl21;
  };
}
