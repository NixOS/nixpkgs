{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  orjson,
  curl-cffi,

  # To build orjson
  rustPlatform,

  # Optional dependencies
  lxml,
}:
let
  curl-cffi_0_7_0 = curl-cffi.overrideAttrs (
    final: old: {
      version = "0.7.0b4";
      src = fetchFromGitHub {
        owner = "yifeikong";
        repo = "curl_cffi";
        rev = "v${final.version}";
        hash = "sha256-txrJNUzswAPeH4Iazn0iKJI0Rqk0HHRoDrtTfDHKMoo=";
      };
    }
  );

  orjson_3_10_3 = orjson.overrideAttrs (
    final: old: {
      version = "3.10.3";
      src = fetchFromGitHub {
        owner = "ijl";
        repo = "orjson";
        rev = "refs/tags/${final.version}";
        hash = "sha256-bK6wA8P/IXEbiuJAx7psd0nUUKjR1jX4scFfJr1MBAk=";
      };
      cargoDeps = rustPlatform.fetchCargoTarball {
        inherit (final) src;
        name = "${old.pname}-${final.version}";
        hash = "sha256-ilGq+/gPSuNwURUWy2ZxInzmUv+PxYMxd8esxrMpr2o=";
      };
    }
  );
in
buildPythonPackage rec {
  pname = "duckduckgo-search";
  version = "v5.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "duckduckgo_search";
    rev = version;
    hash = "sha256-T7rlB3dU7y+HbHr1Ss9KkejlXFORhnv9Va7cFTRtfQU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    click
    orjson_3_10_3
    curl-cffi_0_7_0
  ];

  passthru.optional-dependencies = {
    lxml = [ lxml ];
  };

  doCheck = false; # tests require network access

  pythonImportsCheck = [ "duckduckgo_search" ];

  meta = {
    description = "Python CLI and library for searching for words, documents, images, videos, news, maps and text translation using the DuckDuckGo.com search engine";
    mainProgram = "ddgs";
    homepage = "https://github.com/deedy5/duckduckgo_search";
    changelog = "https://github.com/deedy5/duckduckgo_search/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
