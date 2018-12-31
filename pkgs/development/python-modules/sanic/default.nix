{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, aiofiles, websockets, multidict, ujson, uvloop, httptools
}:

let
  # Ideally, websockets 7.0 will be supported in the future, but
  # for now, sanic requires 6.x
  ws = websockets.overrideAttrs (_: {
    src = fetchPypi {
      pname   = "websockets";
      version = "6.0";
      sha256  = "0v3iqdqizwxajpwasyngkhdfwfqxvh864wl2cch03cy525nrafwg";
    };
  });
in
buildPythonPackage rec {
  pname   = "sanic";
  version = "18.12.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q1z6f5ra5ra194080ps6vld0qyjg2sg982dhkzwlmw5b3czzrac";
  };

  propagatedBuildInputs = [ aiofiles uvloop ujson ws multidict httptools ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Fast, asynchronous Python 3 webserver";
    homepage    = https://sanicframework.org/;
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
