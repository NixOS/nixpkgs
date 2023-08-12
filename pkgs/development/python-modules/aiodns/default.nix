{ lib
, buildPythonPackage
, fetchFromGitHub
, pycares
, pythonOlder
, typing
}:

buildPythonPackage rec {
  pname = "aiodns";
  version = "3.0.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "saghul";
    repo = pname;
    rev = "aiodns-${version}";
    sha256 = "1i91a43gsq222r8212jn4m6bxc3fl04z1mf2h7s39nqywxkggvlp";
  };

  propagatedBuildInputs = [
    pycares
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
  ];

  # Could not contact DNS servers
  doCheck = false;

  pythonImportsCheck = [ "aiodns" ];

  meta = with lib; {
    description = "Simple DNS resolver for asyncio";
    homepage = "https://github.com/saghul/aiodns";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
