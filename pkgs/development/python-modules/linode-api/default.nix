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
  version = "4.1.1b2";
  name = "${pname}-${version}";

  disabled = (pythonOlder "2.7");

  propagatedBuildInputs = [ requests ]
                             ++ stdenv.lib.optionals (!isPy3k) [ future ]
                             ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  postPatch = (stdenv.lib.optionalString (isPy3k) ''
    sed -i -e '/"future",/d' setup.py
  '') + (stdenv.lib.optionalString (!pythonOlder "3.4") ''
    sed -i -e '/"enum34",/d' setup.py
  '');

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lfqsll3wv1wzn98ymmcbw0yawj8ab3mxniws6kaxf99jd4a0xp4";
  };

  meta = {
    homepage = "https://github.com/linode/python-linode-api";
    description = "The official python library for the Linode API v4 in python.";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ glenns ];
  };
}
