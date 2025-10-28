{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyeverlights";
  version = "0.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "joncar";
    repo = "pyeverlights";
    rev = version;
    sha256 = "16xpq933j8yydq78fnf4f7ivyw5a45ix4mfycpmm91aj549p6pm0";
  };

  propagatedBuildInputs = [ aiohttp ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "pyeverlights" ];

  meta = with lib; {
    description = "Python module for interfacing with an EverLights control box";
    homepage = "https://github.com/joncar/pyeverlights";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
