{ stdenv, buildOcaml, fetchFromGitHub, cppo }:

buildOcaml rec {
  name = "merlin_extend";
  version = "0.3";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "merlin-extend";
    sha256 = "1z6hybcb7ry0bkzjd0r2dlcgjnhhxdsr06x3h03sj7h5fihsc7vd";
    rev = "v${version}";
  };

  buildInputs = [ cppo ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/let-def/merlin-extend;
    description = "SDK to extend Merlin";
    license = licenses.mit;
    maintainers = [ maintainers.volth ];
  };
}
