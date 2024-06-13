{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, click
, fake-useragent
, hatchling
, pandas
, pydantic
, python-dotenv
, pytz
, pyyaml
, ratelimit
, requests
, rich
, rich-click
, tenacity
}:

buildPythonPackage rec {
  pname = "camply";
  version = "0.22.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9FW4qdsrpXw9JbZCVB1CyOgvFViFlEBn8sEXiKKuzw4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requests~=2.28.2' 'requests~=2.31.0'
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    click
    fake-useragent
    pandas
    pydantic
    python-dotenv
    pytz
    pyyaml
    ratelimit
    requests
    rich
    rich-click
    tenacity
  ];

  pythonImportsCheckHook = [ "camply" ];

  meta = with lib; {
    description = "Tool to find campsites at sold out campgrounds";
    homepage = "https://github.com/juftin/camply";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ willcohen ];
  };
}
