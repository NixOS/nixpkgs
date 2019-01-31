{ lib, buildPythonPackage, fetchPypi
, adal, msrest }:

buildPythonPackage rec {
  pname = "msrestazure";
  version = "0.6.0";

  # for some reason if i use fetchFromGitHub azure-keyvault can not find it anymore
  src = fetchPypi {
    inherit pname version;
    sha256 = "06s04f6nng4na2663kc12a3skiaqb631nscjfwpsrx4lzkf8bccr";
  };

  propagatedBuildInputs = [ adal msrest ];

  # TypeError: async_poller() missing 4 required positional arguments: 'client',
  # 'initial_response', 'deserialization_callback', and 'polling_method'
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure REST operations";
    homepage = https://github.com/Azure/msrestazure-for-python;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.mit;
  };
}
