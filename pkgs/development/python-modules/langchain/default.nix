{ lib
, buildPythonPackage
, fetchPypi
, mypy
, tenacity
, marshmallow
, greenlet
, pip
, pyyaml
, numpy
, aiohttp
, pydantic
, sqlalchemy
, urllib3
, typing-inspect
, certifi
, requests
, marshmallow-enum
, dataclasses-json
}:

buildPythonPackage rec {
    pname = "langchain";
    version = "0.0.105";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-YZBU2vLrXLaTsOQ3o1Y6j8UaJFy9/EBN1WMvnApEuLU=";
    };

    propagatedBuildInputs =
      [
        mypy
        tenacity
        marshmallow
        greenlet
        pip
        pyyaml
        numpy
        aiohttp
        pydantic
        sqlalchemy
        urllib3
        typing-inspect
        certifi
        requests
        marshmallow-enum
        dataclasses-json
    ];

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/hwchase17/langchain";
      description = "Building applications with LLMs through composability";
      license = licenses.mit;
      maintainers = with maintainers; [ larsr ];
    };
  }
