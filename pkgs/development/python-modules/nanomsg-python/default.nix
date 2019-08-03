{ stdenv, buildPythonPackage, fetchFromGitHub, nanomsg }:

buildPythonPackage rec {
  pname = "nanomsg-python";
  version = "1.0.20190114";

  src = fetchFromGitHub {
    owner = "tonysimpson";
    repo = "nanomsg-python";
    rev = "3acd9160f90f91034d4a43ce603aaa19fbaf1f2e";
    sha256 = "1qgybcpmm9xxrn39alcgdcpvwphgm1glkbnwx0ljpz4nd1jsnyrl";
  };

  buildInputs = [ nanomsg ];

  # Tests requires network connections
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bindings for nanomsg";
    homepage = https://github.com/tonysimpson/nanomsg-python;
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
  };
}
