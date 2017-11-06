{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, mock
}:
buildPythonPackage rec {

  pname = "json-rpc";
  version = "1.10.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dfk8v2bcl0fjjyzbbqr0bybkqzngqa1ra8f40dyrshjsfc4mw11";
  };

  checkInputs = [ nose mock ];

  meta = with stdenv.lib; {
    homepage = http://github.com/pavlov99/json-rpc;
    description = "JSON-RPC2.0 and JSON-RPC1.0 transport specification implementation";
    license = licenses.mit;
  };
}
