{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "openidc-client";
  version = "0.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59d59d6fbfd26c5b57c53e582bdf2379274602f96133a163e7ff1ef39c363353";
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
