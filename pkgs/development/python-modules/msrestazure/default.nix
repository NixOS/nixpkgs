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
  version = "0.6.4";
  pname = "msrestazure";

  # Pypi tarball doesnt include tests
  # see https://github.com/Azure/msrestazure-for-python/pull/133
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrestazure-for-python";
    rev = "v${version}";
    sha256 = "0ik81f0n6r27f02gblgm0vl5zl3wc6ijsscihgvc1fgm9f5mk5b5";
  };

  propagatedBuildInputs = [ adal msrest ];

  nativeCheckInputs = [ httpretty mock pytest ]
                ++ lib.optionals isPy3k [ pytest-asyncio ];

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
