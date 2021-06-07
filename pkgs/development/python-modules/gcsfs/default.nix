{ buildPythonPackage, fetchFromGitHub, lib, pytestCheckHook, google-auth
, google-auth-oauthlib, requests, decorator, fsspec, ujson, aiohttp, crcmod
, pytest-vcr, vcrpy }:

buildPythonPackage rec {
  pname = "gcsfs";
  version = "2021.04.0";

  # github sources needed for test data
  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "sha256-OA43DaQue7R5d6SzfKThEQFEwJndjLfznu1LMubs5fs=";
  };

  propagatedBuildInputs = [
    google-auth
    google-auth-oauthlib
    requests
    decorator
    fsspec
    aiohttp
    ujson
    crcmod
  ];

  checkInputs = [ pytestCheckHook pytest-vcr vcrpy ];
  pythonImportsCheck = [ "gcsfs" ];

  meta = with lib; {
    description = "Convenient Filesystem interface over GCS";
    homepage = "https://github.com/dask/gcsfs";
    license = licenses.bsd3;
    maintainers = [ maintainers.nbren12 ];
  };
}
