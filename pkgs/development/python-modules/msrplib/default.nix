{ stdenv
, buildPythonPackage
, fetchdarcs
, eventlib
, application
, gnutls
}:

buildPythonPackage rec {
  pname = "python-msrplib";
  version = "0.19";

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "0jqvvssbwzq7bwqn3wrjfnpj8zb558mynn2visnlrcma6b57yhwd";
  };

  propagatedBuildInputs = [ eventlib application gnutls ];

  meta = with stdenv.lib; {
    homepage = https://github.com/AGProjects/python-msrplib;
    description = "Client library for MSRP protocol and its relay extension (RFC 4975 and RFC4976)";
    license = licenses.lgpl3;
  };

}
