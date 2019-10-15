{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "1.6.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "034170w0qh20qkfaha2rpnccm31f7snhb4r9cd079v4v2x2swybk";
  };

  nativeBuildInputs = [ setuptools ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
