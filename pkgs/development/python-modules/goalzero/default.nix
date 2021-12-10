{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "goalzero";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "tkdrob";
     repo = "goalzero";
     rev = "v0.2.1";
     sha256 = "091c7jsqwxb5vgq2vkhi1m8vk21zxghlbzbhc1dnv25cdfv2hjv1";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "goalzero"
  ];

  meta = with lib; {
    description = "Goal Zero Yeti REST Api Library";
    homepage = "https://github.com/tkdrob/goalzero";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
