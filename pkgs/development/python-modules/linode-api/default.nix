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
  version = "4.1.1b1";
  name = "${pname}-${version}";

  disabled = (pythonOlder "2.7");

  buildInputs = [];
  propagatedBuildInputs = [ requests ]
                             ++ stdenv.lib.optionals (!isPy3k) [ future ]
                             ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1psf4sknxrjqiz833x4nmh2pw7xi2rvcm7l9lv8jfdwxza63sny5";
  };

  meta = {
    homepage = "https://github.com/linode/python-linode-api";
    description = "The official python library for the Linode API v4 in python.";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ glenns ];
  };
}
