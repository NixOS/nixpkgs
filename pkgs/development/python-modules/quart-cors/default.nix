{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, quart
, pytestCheckHook
, pytest-cov
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "quart-cors";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "quart-cors";
    rev = "refs/tags/${version}";
    hash = "sha256-fSSIHv0bXoyOy9Z1ErKqXqrLlq88ghZaCVAmuUb5Y2c";
  };

  patches = [
    (fetchpatch {
      name = "quart-testing-rename";
      url = "https://github.com/pgjones/quart-cors/commit/b7c156cf6a7dc4c4ec7211a851a212c7a2832eab.patch";
      hash = "sha256-2Wm7BoJNMw3PJR2yiomst4KUKKYX1x3gUXwzcyu1RX0=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ quart ];

  checkInputs = [ pytestCheckHook pytest-cov pytest-asyncio ];

  meta = with lib; {
    changelog = "https://github.com/pgjones/quart-cors/releases/tag/${version}";
    description = "Quart-CORS is an extension for Quart to enable and control Cross Origin Resource Sharing, CORS.";
    homepage = "https://github.com/pgjones/quart-cors";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
  };
}
