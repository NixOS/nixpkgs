{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aionanoleaf";
  version = "0.0.2";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fmzmbsmfsa1ixxcz8vckg8qmsip8y7gih1j23jrlfbjm9s5jf5p";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aionanoleaf" ];

  meta = with lib; {
    description = "Python wrapper for the Nanoleaf API";
    homepage = "https://github.com/milanmeu/aionanoleaf";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
