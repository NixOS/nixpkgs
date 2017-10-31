{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "openidc-client";
  version = "0.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fca4bpnswyji5nivsrbak5vsfphl4njyfrb8rm2034nq6mzb8ah";
  };
  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A CLI python OpenID Connect client with token caching and management";
    homepage = https://github.com/puiterwijk;
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler ];
  };
}
