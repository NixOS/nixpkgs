{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pretend";
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c90eb810cde8ebb06dafcb8796f9a95228ce796531bc806e794c2f4649aa1b10";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/alex/pretend";
    license = licenses.bsd3;
  };
}
