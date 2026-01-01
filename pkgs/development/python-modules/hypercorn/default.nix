{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aioquic,
  cacert,
  h11,
  h2,
  httpx,
  priority,
  trio,
  uvloop,
  wsproto,
  poetry-core,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hypercorn";
  version = "0.17.3";
  pyproject = true;

  disabled = pythonOlder "3.11"; # missing taskgroup dependency

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "Hypercorn";
    tag = version;
    hash = "sha256-AtSMURz1rOr6VTQ7L2EQ4XZeKVEGTPXTbs3u7IhnZo8";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    h11
    h2
    priority
    wsproto
  ];

  optional-dependencies = {
    h3 = [ aioquic ];
    trio = [ trio ];
    uvloop = [ uvloop ];
  };

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytest-trio
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "hypercorn" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/pgjones/hypercorn/blob/${src.tag}/CHANGELOG.rst";
    homepage = "https://github.com/pgjones/hypercorn";
    description = "ASGI web server inspired by Gunicorn";
    mainProgram = "hypercorn";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dgliwka ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
