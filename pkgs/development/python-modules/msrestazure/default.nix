{ pkgs
, buildPythonPackage
, fetchPypi
, python
, adal
, msrest
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "msrestazure";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06s04f6nng4na2663kc12a3skiaqb631nscjfwpsrx4lzkf8bccr";
  };

  propagatedBuildInputs = [ adal msrest ];

  meta = with pkgs.lib; {
    description = "The runtime library 'msrestazure' for AutoRest generated Python clients.";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas ];
  };
}
