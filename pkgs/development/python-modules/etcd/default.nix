{ lib
, buildPythonPackage
, fetchurl
, simplejson
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "etcd";
  version = "2.0.8";

  # PyPI package is incomplete
  src = fetchurl {
    url = "https://github.com/dsoprea/PythonEtcdClient/archive/${version}.tar.gz";
    sha256 = "0fi6rxa1yxvz7nwrc7dw6fax3041d6bj3iyhywjgbkg7nadi9i8v";
  };

  patchPhase = ''
    sed -i -e '13,14d;37d' setup.py
  '';

  propagatedBuildInputs = [ simplejson pytz requests ];

  # No proper tests are available
  doCheck = false;

  meta = with lib; {
    description = "A Python etcd client that just works";
    homepage = "https://github.com/dsoprea/PythonEtcdClient";
    license = licenses.gpl2;
  };

}
