{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  python-memcached,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiomcache";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiomcache";
    rev = "v${version}";
    hash = "sha256-+rlKHDop0kNxJ0HoXROs/oyI4zE3MDyxXXhWZtVDMj4=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-memcached ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  doCheck = false; # executes memcached in docker

  pythonImportsCheck = [ "aiomcache" ];

  meta = with lib; {
    changelog = "https://github.com/aio-libs/aiomcache/blob/${src.rev}/CHANGES.rst";
    description = "Minimal asyncio memcached client";
    homepage = "https://github.com/aio-libs/aiomcache/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
