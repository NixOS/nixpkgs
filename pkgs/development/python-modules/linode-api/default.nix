{ stdenv,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pythonOlder,
  lib,
  requests,
  future,
  enum34 }:

buildPythonPackage rec {
  pname = "linode-api";
  version = "4.1.8b1"; # NOTE: this is a beta, and the API may change in future versions.
  name = "${pname}-${version}";

  disabled = (pythonOlder "2.7");

  propagatedBuildInputs = [ requests future ]
                             ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  postPatch = (stdenv.lib.optionalString (!pythonOlder "3.4") ''
    sed -i -e '/"enum34",/d' setup.py
  '');

  doCheck = false; # This library does not have any tests at this point.

  src = fetchPypi {
    inherit pname version;
    sha256 = "0afwqccbdmdnjc3glvn65qz0pmrbs3fa89z3wig2w4v15608p20s";
  };

  meta = {
    homepage = "https://github.com/linode/python-linode-api";
    description = "The official python library for the Linode API v4 in python.";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ glenns ];
  };
}
