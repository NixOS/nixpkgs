{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, freezegun
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiorecollect";
  version = "2023.08.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-oTkWirq3w0DgQWWe0ziK+ry4pg6j6SQbBESLG4xgDE4=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/aiorecollect/pull/207
    #
    (fetchpatch {
      name = "clean-up-dependencies.patch";
      url = "https://github.com/bachya/aiorecollect/commit/0bfddead1c1b176be4d599b8e12ed608eac97b8b.patch";
      hash = "sha256-w/LAtyuyYsAAukDeIy8XLlp9QrydC1Wmi2zxEj1Zdm8=";
      includes = [ "pyproject.toml" ];
    })
  ];

  postPatch = ''
    # this is not used directly by the project
    sed -i '/certifi =/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "aiorecollect"
  ];

  meta = with lib; {
    description = "Python library for the Recollect Waste API";
    longDescription = ''
      aiorecollect is a Python asyncio-based library for the ReCollect
      Waste API. It allows users to programmatically retrieve schedules
      for waste removal in their area, including trash, recycling, compost
      and more.
    '';
    homepage = "https://github.com/bachya/aiorecollect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
