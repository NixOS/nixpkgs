{ stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  pythonOlder,
  lib,
  requests,
  future,
  enum34,
  mock }:

buildPythonPackage rec {
  pname = "linode-api";
  version = "4.1.8b1"; # NOTE: this is a beta, and the API may change in future versions.

  disabled = (pythonOlder "2.7");

  propagatedBuildInputs = [ requests future ]
                             ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  postPatch = (stdenv.lib.optionalString (!pythonOlder "3.4") ''
    sed -i -e '/"enum34",/d' setup.py
  '');

  doCheck = true;
  checkInputs = [ mock ];

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "linode";
    repo = "python-linode-api";
    sha256 = "0qfqn92fr876dncwbkf2vhm90hnf7lwpg80hzwyzyzwz1hcngvjg";
  };

  meta = {
    homepage = "https://github.com/linode/python-linode-api";
    description = "The official python library for the Linode API v4 in python.";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ glenns ];
  };
}
