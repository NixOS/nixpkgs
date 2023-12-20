{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "emulated-roku";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mindigmarton";
    repo = "emulated_roku";
    rev = version;
    sha256 = "02cbg5wrph19p6x44jlw6cn3jli0kwbgfh6klb3c4k5jfrkhgghw";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "emulated_roku" ];

  meta = with lib; {
    description = "Library to emulate a roku server to serve as a proxy for remotes such as Harmony";
    homepage = "https://github.com/mindigmarton/emulated_roku";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
