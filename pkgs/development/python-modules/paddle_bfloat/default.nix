{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonAtLeast
, python
}:
let
  pname = "paddle_bfloat";
  version = "0.1.7";
  format = "wheel";
  pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
  binary-hash = (import ./binary-hashes.nix)."${pyShortVersion}" or {};
  src = fetchPypi ({
    inherit pname version format;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
  } // binary-hash);
in
buildPythonPackage {
  inherit pname version format src;

  disabled = pythonOlder "3.9" || pythonAtLeast "3.12";

  propagatedBuildInputs = [
  ];

  meta = with lib; {
    description = "Paddle numpy bfloat16 package";
    homepage = "https://pypi.org/project/paddle-bfloat";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.linux;
  };
}
