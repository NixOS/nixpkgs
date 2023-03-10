{ lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, fetchpatch
, libuv
}:

buildPythonPackage rec {
  pname = "pyuv";
  version = "1.4.0";
  disabled = pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "saghul";
    repo = "pyuv";
    rev = "pyuv-${version}";
    sha256 = "1wiwwdylz66lfsjh6p4iv7pfhzvnhwjk332625njizfhz3gq9fwr";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-with-python3.10.patch";
      url = "https://github.com/saghul/pyuv/commit/8bddcc27052017b5b9cb89c24dbfdf06737b0dd3.patch";
      sha256 = "sha256-J/3ky64Ff+gYpN3ksFLNuZ5xgPbBkyOl4LTY6fiHAgk=";
    })
  ];

  setupPyBuildFlags = [ "--use-system-libuv" ];

  buildInputs = [ libuv ];

  doCheck = false; # doesn't work in sandbox

  pythonImportsCheck = [ "pyuv" ];

  meta = with lib; {
    description = "Python interface for libuv";
    homepage = "https://github.com/saghul/pyuv";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
