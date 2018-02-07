{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "jsonrpclib-pelix";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qs95vxplxwspbrqy8bvc195s58iy43qkf75yrjfql2sim8b25sl";
  };

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = https://pypi.python.org/pypi/jsonrpclib-pelix/;
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ moredread ];
  };
}
