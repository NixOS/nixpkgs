{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, inflection
, pyjwt
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

let
  # https://github.com/mdz/python-smarttub/issues/10
  pyjwt' = pyjwt.overridePythonAttrs (oldAttrs: rec {
    version = "1.7.1";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96";
    };
  });
in

buildPythonPackage rec {
  pname = "python-smarttub";
  version = "0.0.19";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mdz";
    repo = pname;
    rev = "v${version}";
    sha256 = "01i4pvgvpl7inwhy53c6b34pi5zvfiv2scn507j8jdg5cjs04g80";
  };

  propagatedBuildInputs = [
    aiohttp
    inflection
    pyjwt'
    python-dateutil
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "smarttub" ];

  meta = with lib; {
    description = "Python API for SmartTub enabled hot tubs";
    homepage = "https://github.com/mdz/python-smarttub";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
