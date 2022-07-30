{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry
, aiohttp
, beautifulsoup4
, dataclasses-json
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "linkedin-messaging";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "linkedin-messaging-api";
    rev = "v${version}";
    sha256 = "sha256-Jjhaua9zUDX+dMaaFNKVf2cojRIfiVjHZvNlmJHw8rc=";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    dataclasses-json
  ];

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "linkedin_messaging" ];

  meta = with lib; {
    description = "An unofficial API for interacting with LinkedIn Messaging.";
    homepage = "https://github.com/sumnerevans/linkedin-messaging-api";
    license = licenses.asl20;
    maintainers = [ maintainers.sumnerevans ];
  };
}
