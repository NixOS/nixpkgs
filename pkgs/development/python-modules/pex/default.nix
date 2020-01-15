{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "1.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zibkc074dvk69bkiipfzn2l9glgzs26g16j2ny5lzq320wqszkj";
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
