{ lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, libuv
}:

buildPythonPackage rec {
  pname = "pyuv";
  version = "1.4.0";
  disabled = pythonAtLeast "3.10"; # https://github.com/saghul/pyuv/issues/273

  src = fetchFromGitHub {
    owner = "saghul";
    repo = "pyuv";
    rev = "pyuv-${version}";
    sha256 = "1wiwwdylz66lfsjh6p4iv7pfhzvnhwjk332625njizfhz3gq9fwr";
  };

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
