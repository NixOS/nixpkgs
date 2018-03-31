{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "readlike";
  version = "0.1.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1ck65ycw51f4xnbh4sg9axgbl81q3azpzvd5f2nvrv2fla9m8r08";
  };
  name = "${pname}-${version}";
 
  meta = {
    homepage = http://jangler.info/code/readlike;
    description = "GNU Readline-like line editing module";
    license = lib.licenses.mit;
  };
}  
