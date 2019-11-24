{ pkgs
, lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, adal
, msrest
, mock
, httpretty
, pytest
, pytest-asyncio
}:

buildPythonPackage rec {
  version = "0.6.2";
  pname = "msrestazure";

  # Pypi tarball doesnt include tests
  # see https://github.com/Azure/msrestazure-for-python/pull/133
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrestazure-for-python";
    rev = "v${version}";
    sha256 = "09qwdg4la4jwp5ibypdwsn7h8m2sh8c1kdxvffyxcjan50h14s04";
  };

  propagatedBuildInputs = [ adal msrest ];

  checkInputs = [ httpretty mock pytest ]
                ++ lib.optional isPy3k [ pytest-asyncio ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with pkgs.lib; {
    description = "The runtime library 'msrestazure' for AutoRest generated Python clients.";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas jonringer ];
  };
}
