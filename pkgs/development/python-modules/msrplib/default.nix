{ stdenv
, buildPythonPackage
, fetchdarcs
, eventlib
, application
, gnutls
}:

buildPythonPackage rec {
  pname = "python-msrplib";
  version = "0.19.2";

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "0d0krwv4hhspjgppnvh0iz51bvdbz23cjasgrppip7x8b00514gz";
  };

  propagatedBuildInputs = [ eventlib application gnutls ];

  meta = with stdenv.lib; {
    homepage = https://github.com/AGProjects/python-msrplib;
    description = "Client library for MSRP protocol and its relay extension (RFC 4975 and RFC4976)";
    license = licenses.lgpl3;
  };

}
